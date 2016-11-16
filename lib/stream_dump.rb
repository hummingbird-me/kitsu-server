module StreamDump
  class Story < ActiveRecord::Base
    default_scope { where(deleted_at: nil) }

    has_many :substories
    belongs_to :library_entry
  end
  class Substory < ActiveRecord::Base
    STATUS_KEYS = {
      'Currently Watching' => 'current',
      'Plan to Watch' => 'planned',
      'Completed' => 'completed',
      'On Hold' => 'on_hold',
      'Dropped' => 'dropped'
    }

    default_scope { where(deleted_at: nil) }

    belongs_to :story
    belongs_to :user
    belongs_to :target, polymorphic: true

    enum substory_type: {
      followed: 0,
      status_update: 1,
      comment: 2,
      progress: 3,
      reply: 4
    }

    scope :for_user, -> (user_id) { where(user_id: user_id) }
    scope :media_update, -> { where(substory_type: [1, 3]) }
    scope :with_library_entry, -> {
      includes(story: { library_entry: %i[user media] })
    }

    def activity
      MediaActivityService.new(story.library_entry)
    end

    def progress
      data['episode_number']
    end

    def status
      STATUS_KEYS[data['new_status']]
    end

    def stream_activity
      return unless story&.library_entry
      case substory_type
      when 'status_update' then activity.status(status)
      when 'progress' then activity.progress(progress)
      end.tap do |activity|
        activity.time = created_at
      end
    end
  end

  class UnmentioningPost < Post
    scope :by_user, -> (user) { where(user: user) }
    scope :groupless, -> { where(group_id: nil) }

    def stream_activity
      media_feed = Feed.media(media_type, media_id) if media_id
      target_user_feed = Feed.user(target_user_id) if target_user_id
      user.feed.activities.new(
        updated_at: updated_at,
        post_likes_count: post_likes_count,
        comments_count: comments_count,
        content: content,
        to: [media_feed, target_user_feed]
      )
    end
  end

  module_function

  def posts(scope = User)
    each_user(scope) do |user_id|
      posts = UnmentioningPost.groupless.by_user(user_id).includes(:user)
      next if posts.blank?
      data = posts.find_each.map(&:complete_stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.user(user_id).stream_id,
        data: data
      }
    end
  end

  def stories(scope = User)
    each_user(scope) do |user_id|
      substories = Substory.for_user(user_id).media_update.with_library_entry
      next if substories.blank?
      data = substories.find_each.map(&:stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.user(user_id).stream_id,
        data: data
      }
    end
  end

  def follows(scope = User)
    each_user(scope) do |user_id|
      follows = Follow.where(follower: user_id).pluck(:followed_id)
      follow_self = [Feed.user(user_id).stream_id]
      {
        instruction: 'follow',
        feedId: Feed.timeline(user_id).stream_id,
        data: follows.map { |uid| Feed.user(uid).stream_id } + follow_self
      }
    end
  end

  def auto_follows
    users = each_user do |user_id|
      {
        instruction: 'follow',
        feedId: Feed.user_aggr(user_id).stream_id,
        data: [Feed.user(user_id).stream_id]
      }
    end
    media = each_media do |type, id|
      {
        instruction: 'follow',
        feedId: Feed.media_aggr(type, id).stream_id,
        data: [Feed.media(type, id).stream_id]
      }
    end
    [users, media].lazy.flat_map { |list| list }
  end

  def each_user(scope = User, &block)
    each_id(scope, 'User', &block)
  end

  def each_anime(scope = Anime, &block)
    each_id(scope, 'Anime', &block)
  end

  def each_manga(scope = Manga, &block)
    each_id(scope, 'Manga', &block)
  end

  def each_drama(scope = Drama, &block)
    each_id(scope, 'Drama', &block)
  end

  def each_media(&block)
    [
      each_anime { |id| block.('Anime', id) },
      each_manga { |id| block.('Manga', id) },
      each_drama { |id| block.('Drama', id) }
    ].lazy.flat_map { |list| list }
  end

  def each_id(scope, title, &block)
    items = scope.pluck(:id).each.lazy
    bar = progress_bar(title, scope.count(:all))
    items.map(&block).map { |i| bar.increment; i }.reject(&:nil?)
  end

  def progress_bar(title, count)
    ProgressBar.create(
      title: title,
      total: count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
  end
end

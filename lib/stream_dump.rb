Dir['lib/stream_dump/*'].each do |file|
  require_dependency(File.expand_path(file))
end

module StreamDump
  module_function

  def split_profiles(scope = User)
    results = each_user(scope) do |user_id|
      # Split the feed
      split_feed(ProfileFeed.new(user_id))
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_media
    results = each_media do |media_type, media_id|
      split_feed(MediaFeed.new(media_type, media_id))
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_timelines(scope = User)
    results = each_user(scope) do |user_id|
      split_feed(TimelineFeed.new(user_id))
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def private_library_feed(scope = User)
    each_user(scope) do |user_id|
      entries = LibraryEntry.where(user_id: user_id)
                            .pluck(:id, :status, :rating, :progress,
                              :updated_at, :media_type, :media_id)
      entries = entries.map do |(id, status, rating, progress, updated_at,
                                 media_type, media_id)|
        [
          {
            # STATUS
            verb: 'updated',
            foreign_id: "LibraryEntry:#{id}:updated-#{status}",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            status: status,
            time: updated_at
          },
          {
            # RATING
            verb: 'rated',
            foreign_id: "LibraryEntry:#{id}:rated",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            rating: rating,
            time: updated_at
          },
          {
            # PROGRESS
            verb: 'progressed',
            foreign_id: "LibraryEntry:#{id}:progressed-#{progress}",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            progress: progress,
            time: updated_at
          }
        ]
      end
      entries = entries.flat_map { |x| x }

      {
        instruction: 'add_activities',
        feedId: "private_library:#{user_id}",
        data: entries
      }
    end
  end

  def group_timeline_migration(scope = User)
    results = each_user(scope) do |user_id|
      group_ids = GroupMember.where(user_id: user_id).pluck(:group_id)
      group_feeds = group_ids.map { |id| "group:#{id}" }

      [
        {
          instruction: 'follow',
          feedId: "group_timeline:#{user_id}",
          data: group_feeds
        },
        {
          instruction: 'unfollow',
          feedId: "timeline:#{user_id}",
          data: group_feeds
        }
      ]
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_feed(feed)
    activities = feed.activities_for(type: :flat).unenriched.to_enum

    posts_activities = []
    media_activities = []
    posts_feed = feed.stream_feed_for(filter: :posts).stream_id
    media_feed = feed.stream_feed_for(filter: :media).stream_id

    activities.each do |act|
      if Feed::MEDIA_VERBS.include?(act.verb)
        media_activities << act.activities.first
      elsif Feed::POST_VERBS.include?(act.verb)
        posts_activities << act.activities.first
      end
    end

    [
      {
        instruction: 'add_activities',
        feedId: media_feed,
        data: media_activities.map(&:as_json)
      },
      {
        instruction: 'add_activities',
        feedId: posts_feed,
        data: posts_activities.map(&:as_json)
      }
    ]
  end

  def posts(scope = User)
    each_user(scope) do |user_id|
      posts = StreamDump::Post.for_user(user_id).includes(:user)
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

  def group_posts(scope = Group)
    each_group(scope) do |group_id|
      posts = StreamDump::Post.for_group(group_id).includes(:user)
      next if posts.blank?
      data = posts.find_each.map(&:complete_stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.group(group_id).stream_id,
        data: data
      }
    end
  end

  def stories(scope = User)
    each_user(scope) do |user_id|
      substories = StreamDump::Substory.for_user(user_id).media_update
                                       .with_library_entry
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

  def group_memberships(scope = User)
    each_user(scope) do |user_id|
      groups = GroupMember.where(user: user_id).pluck(:group_id)
      {
        instruction: 'follow',
        feedId: Feed.timeline(user_id).stream_id,
        data: groups.map { |gid| Feed.group(gid).stream_id }
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

  def group_auto_follows
    each_group do |group_id|
      {
        instruction: 'follow',
        feedId: Feed.group_aggr(group_id).stream_id,
        data: [Feed.group(group_id).stream_id]
      }
    end
  end

  def each_user(scope = User, &block)
    each_id(scope, 'User', &block)
  end

  def each_group(scope = Group, &block)
    each_id(scope, 'Group', &block)
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

  def each_media
    [
      each_anime { |id| yield 'Anime', id },
      each_manga { |id| yield 'Manga', id },
      each_drama { |id| yield 'Drama', id }
    ].lazy.flat_map { |list| list }
  end

  def each_id(scope, title, &block)
    items = scope.pluck(:id).each.lazy
    bar = progress_bar(title, scope.count(:all))
    # HACK: Normally we'd use #each because we don't want to modify the values,
    # but we need to stay lazy, and Enumerator::Lazy#each will collapse the
    # laziness.
    items.map(&block).map { |i|
      bar.increment
      i
    }.reject(&:nil?)
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

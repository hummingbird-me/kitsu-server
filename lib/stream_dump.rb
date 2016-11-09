class StreamDump
  class Story < ActiveRecord::Base
    default_scope { where(deleted_at: nil) }

    has_many :substories
    belongs_to :library_entry
  end
  class Substory < ActiveRecord::Base
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
    scope :with_library_entry, -> { includes(story: [:library_entry]) }

    def activity
      MediaActivityService.new(story.library_entry)
    end

    def stream_activity
      case substory_type
      when :status_update then activity.status(status)
      when :progress then activity.progress(progress)
      end
    end
  end

  module_function

  def posts
   User.pluck(:id).map do |user_id|
     posts = Post.where(user_id: user_id)
     next if posts.blank?
     {
       instruction: 'add_activities',
       feedId: Feed.user(user_id).stream_id,
       data: posts.find_each.map(&:complete_stream_activity)
     }
    end
  end

  def stories(scope = User)
    scope.pluck(:id).map do |user_id|
      substories = Substory.for_user(user_id).media_update.with_library_entry
      next if stories.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.user(user_id).stream_id,
        data: substories.find_each.map(&:stream_activity)
      }
    end
  end
end

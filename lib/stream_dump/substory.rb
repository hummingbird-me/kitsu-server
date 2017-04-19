module StreamDump
  class Substory < ActiveRecord::Base
    STATUS_KEYS = {
      'Currently Watching' => 'current',
      'Plan to Watch' => 'planned',
      'Completed' => 'completed',
      'On Hold' => 'on_hold',
      'Dropped' => 'dropped'
    }.freeze

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

    scope :for_user, ->(user_id) { where(user_id: user_id) }
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
end

module WithActivity
  extend ActiveSupport::Concern

  included do
    after_commit ->(obj) {
      real_action = obj.try(:deleted_at).nil? ? :update : :destroy
      obj.complete_stream_activity.try(real_action)
    }, on: :update
    after_commit ->(obj) { obj.complete_stream_activity&.create }, on: :create
    after_commit ->(obj) { obj.complete_stream_activity&.destroy }, on: :destroy
  end

  # Call on stream_activity and fill in some defaults
  def complete_stream_activity
    stream_activity&.tap do |activity|
      activity.actor ||= user if respond_to?(:user)
      activity.object ||= self
      activity.foreign_id ||= activity.object
      activity.verb ||= activity.object.class.name.underscore
      activity.time ||= activity.object.created_at
    end
  end
end

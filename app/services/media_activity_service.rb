class MediaActivityService
  attr_reader :library_entry
  delegate :media, to: :library_entry
  delegate :user, to: :library_entry

  def initialize(library_entry)
    @library_entry = library_entry
  end

  def status(status)
    user.feed.activities.new(
      verb: 'updated',
      status: status
    )
  end

  def rating(rating)
    user.feed.activities.new(
      verb: 'rated',
      rating: rating,
    )
  end

  def progress(progress, unit = nil)
    user.feed.activities.new(
      verb: 'progressed',
      progress: progress,
      unit: unit
    )
  end

  def reviewed(review)
    user.feed.activities.new(
      verb: 'reviewed',
      review: review
    )
  end

  def fill_defaults(activity)
    activity.tap do |activity|
      activity.actor ||= user
      activity.object ||= library_entry
      activity.to ||= []
      activity.to << media&.feed
      activity.data[:media] ||= media
      activity.foreign_id ||= library_entry
      activity.updated_at ||= library_entry.updated_at
      activity.time ||= library_entry.updated_at
    end
  end
end

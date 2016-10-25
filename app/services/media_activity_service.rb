class MediaActivityService
  attr_reader :library_entry
  delegate :media, to: :library_entry
  delegate :user, to: :library_entry

  def initialize(library_entry)
    @library_entry = library_entry
  end

  def status(status)
    fill_defaults user.feed.activities.new(
      verb: 'updated',
      status: status
    )
  end

  def rating(rating)
    fill_defaults user.feed.activities.new(
      verb: 'rated',
      rating: rating,
    )
  end

  def progress(progress, unit = nil)
    fill_defaults user.feed.activities.new(
      verb: 'progressed',
      progress: progress,
      unit: unit
    )
  end

  def reviewed(review)
    fill_defaults user.feed.activities.new(
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
      activity.media ||= media
      activity.foreign_id ||= library_entry
      activity.time ||= Time.now
    end
  end
end

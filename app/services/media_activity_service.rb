class MediaActivityService
  attr_reader :library_entry
  delegate :media, to: :library_entry
  delegate :user, to: :library_entry

  def initialize(library_entry)
    @library_entry = library_entry
  end

  def status(status)
    fill_defaults user.profile_feed.activities.new(
      foreign_id: "LibraryEntry:#{library_entry.id}:updated-#{status}",
      verb: 'updated',
      status: status
    )
  end

  def rating(rating)
    fill_defaults user.profile_feed.activities.new(
      foreign_id: "LibraryEntry:#{library_entry.id}:rated",
      verb: 'rated',
      rating: rating,
      nineteen_scale: true,
      time: Date.today.to_time
    )
  end

  def progress(progress, unit = nil)
    return if progress.zero?
    fill_defaults user.profile_feed.activities.new(
      verb: 'progressed',
      foreign_id: "LibraryEntry:#{library_entry.id}:progressed-#{progress}",
      progress: progress,
      unit: unit
    )
  end

  def reviewed(review)
    fill_defaults user.profile_feed.activities.new(
      foreign_id: review,
      verb: 'reviewed',
      review: review
    )
  end

  def fill_defaults(activity)
    activity.tap do |act|
      act.actor ||= user
      act.object ||= library_entry
      act.to ||= []
      act.to << media&.feed&.no_fanout
      act.to << user.library_feed
      act.media ||= media
      act.nsfw ||= media.try(:nsfw?)
      act.foreign_id ||= library_entry
      act.time ||= Time.now
    end
  end
end

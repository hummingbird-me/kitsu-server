class AiringNotificationSendWorker
  include Sidekiq::Worker

  def perform(kind, id)
    media = kind.safe_constantize.find(id)
    number = media.release_schedule.occurrences_between(
      media.start_date - 1.week,
      6.hours.ago
    ).count + 1
    unit = media.unit(number)

    media.airing_feed.activities.new(
      actor: media,
      object: unit,
      foreign_id: unit,
      verb: 'aired',
      time: Time.now
    ).create
  end
end

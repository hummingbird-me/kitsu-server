class AiringNotificationScheduleWorker
  include Sidekiq::Worker

  def perform(klass_name)
    klass = klass_name.safe_constantize
    klass.current.where.not(release_schedule: nil).each do |media|
      airings = media.release_schedule.occurrences_between(Time.now, 7.days.from_now)
      airings.each do |airing|
        AiringNotificationSendWorker.perform_at(airing, klass_name, media.id)
      end
    end
  end
end

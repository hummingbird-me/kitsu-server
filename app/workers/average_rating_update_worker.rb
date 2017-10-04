class AverageRatingUpdateWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform(klass_name)
    klass_name.constantize.update_average_ratings
  end
end

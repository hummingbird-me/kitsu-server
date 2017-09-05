class UpdateRatingFrequencyWorker
  include Sidekiq::Worker

  def perform(klass_name, klass_id, query)
    klass = klass_name.safe_constantize
    klass_obj = klass.find(klass_id)
    klass.where(id: klass_id).update_all(query)
    klass_obj.touch
  end
end

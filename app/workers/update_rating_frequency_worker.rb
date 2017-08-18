class UpdateRatingFrequencyWorker
  include Sidekiq::Worker

  def perform(class_obj, query)
    class_obj.class.where(id: id).update_all(query)
    class_obj.touch
  end
end

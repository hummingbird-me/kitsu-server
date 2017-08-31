class UpdateRatingFrequencyWorker
  include Sidekiq::Worker

  def perform(class_name, class_id, query)
    class_ = class_name.safe_constantize
    class_obj = class_.find(class_id)
    class_.where(id: class_id).update_all(query)
    class_obj.touch
  end
end

class DestructionWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'soon'

  def perform(klass, id)
    klass.constantize.unscoped.find(id).destroy!
  rescue ActiveRecord::RecordNotFound
  end
end

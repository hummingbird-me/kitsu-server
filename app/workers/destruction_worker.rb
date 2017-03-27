class DestructionWorker
  include Sidekiq::Worker

  def perform(klass, id)
    klass.constantize.unscoped.find(id).destroy
  end
end

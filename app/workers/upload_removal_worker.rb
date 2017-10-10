class UploadRemovalWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'later'

  def perform
    Upload.orphan.destroy_all
  end
end

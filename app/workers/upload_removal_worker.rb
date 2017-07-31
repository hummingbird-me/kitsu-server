class UploadRemovalWorker
  include Sidekiq::Worker

  def perform
    Upload.orphan.destroy_all
  end
end

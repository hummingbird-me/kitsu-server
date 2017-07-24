class UploadRemovalWorker
  include Sidekiq::Worker

  def perform
    Upload.where(
      post: nil,
      comment: nil
    ).where(
      ['created_at > ?', 11.hours.ago]
    ).destroy_all
  end
end

class ShrineDerivativeWorker
  include Sidekiq::Worker

  def self.perform_async(attacher)
    super(attacher.class.name, attacher.record.to_global_id, attacher.name, attacher.file_data)
  end

  def perform(attacher_class, record, name, file_data)
    attacher_class = attacher_class.safe_constantize
    record = GlobalID::Locator.locate(record)

    attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
    attacher.create_derivatives
    attacher.atomic_persist
  rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
    attacher&.destroy_attached
  end
end

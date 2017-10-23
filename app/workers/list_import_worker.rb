class ListImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'now'

  def perform(import_id)
    import = ListImport.find_by(id: import_id)
    import&.apply!
  end

  def self.perform_async(*args, queue: 'now')
    client_push(class: self, args: args, queue: queue)
  end
end

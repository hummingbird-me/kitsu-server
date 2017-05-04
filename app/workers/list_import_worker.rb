class ListImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = ListImport.find_by(id: import_id)
    import&.apply!
  end
end

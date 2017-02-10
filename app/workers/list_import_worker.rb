class ListImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    Chewy.strategy(:atomic) do
      import = ListImport.find(import_id)
      import.apply!
    end
  end
end

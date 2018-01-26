module Zorro
  class FollowImportWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'soon'

    def perform(user_id)
      user = User.find(user_id)
      Zorro::Importer::FollowImporter.run_for(user)
    end
  end
end

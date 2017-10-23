module ListSync
  class DestroyWorker
    include Sidekiq::Worker
    include ListSync::ErrorHandling
    sidekiq_options retry: 3, queue: 'soon'

    def perform(linked_account_id, media_type, media_id)
      linked_account = LinkedAccount.find(linked_account_id)
      media_class = media_type.safe_constantize
      media = media_class.find(media_id)
      logs = LibraryEntryLog.where(media: media, linked_account: linked_account)
                            .pending

      capture_sync_errors(linked_account, logs) do
        linked_account.list_sync.destroy!(media)
        logs.each { |log| log.update!(sync_status: :success) }
      end
    end
  end
end

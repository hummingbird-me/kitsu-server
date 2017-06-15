module ListSync
  class DestroyWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3, queue: 'sync'

    def perform(linked_account_id, media_type, media_id)
      linked_account = LinkedAccount.find(linked_account_id)
      pending_logs = LibraryEntryLog.where(media_type: media_type,
                                           media_id: media_id,
                                           linked_account_id: linked_account_id)
                                    .pending

      media_class = media_type.safe_constantize
      media = media_class.find(media_id)

      linked_account.list_sync.destroy!(media)
      pending_logs.update!(sync_status: :success)
    rescue ListSync::AuthenticationError
      linked_account.update!(sync_to: false, disabled_reason: 'Login failed')
    rescue ListSync::RemoteError => e
      pending_logs.update!(sync_status: :error, error_message: e.message)
      raise
    end
  end
end

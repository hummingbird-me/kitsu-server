module ListSync
  class UpdateWorker
    include Sidekiq::Worker
    sidekiq_options retry: 3, queue: 'sync'

    def perform(linked_account_id, library_entry_id)
      linked_account = LinkedAccount.find(linked_account_id)
      library_entry = LibraryEntry.find(library_entry_id)
      pending_logs = LibraryEntryLog.for_entry(library_entry).pending

      linked_account.list_sync.update!(library_entry)
      pending_logs.update!(sync_status: :success)
    rescue ListSync::AuthenticationError
      linked_account.update!(sync_to: false, disabled_reason: 'Login failed')
    rescue ListSync::RemoteError => e
      pending_logs.update!(sync_status: :error, error_message: e.message)
      raise
    end
  end
end

module ListSync
  class SyncWorker
    include Sidekiq::Worker
    sidekiq_options retry: false, queue: 'sync'

    def perform(linked_account_id, user_id)
      user = User.find(user_id)
      linked_account = LinkedAccount.find(linked_account_id)
      entries = user.library_entries
      entries.map do |le|
        LibraryEntryLog.create_for(:update, le, linked_account)
      end
      pending_logs = LibraryEntryLog.pending

      linked_account.list_sync.sync!(:anime)
      linked_account.list_sync.sync!(:manga)
      pending_logs.update!(sync_status: :success)
    rescue ListSync::AuthenticationError
      linked_account.update!(sync_to: false, disabled_reason: 'Login failed')
    rescue ListSync::RemoteError => e
      pending_logs.update!(sync_status: :error, error_message: e.message)
      raise
    end
  end
end

module ListSync
  class SyncWorker
    include Sidekiq::Worker
    include ListSync::ErrorHandling
    sidekiq_options retry: false, queue: 'soon', debounce: true

    def perform(linked_account_id, user_id)
      user = User.find(user_id)
      linked_account = LinkedAccount.find(linked_account_id)
      entries = user.library_entries

      %i[anime manga].each do |kind|
        # Create Logs
        logs = entries.by_kind(kind).map do |le|
          LibraryEntryLog.create_for(:update, le, linked_account)
        end
        capture_sync_errors(linked_account, logs) do
          # Sync 'em
          linked_account.list_sync.sync!(kind)
          # Mark logs as done
          logs.each { |log| log.update!(sync_status: :success) }
        end
      end
    end
  end
end

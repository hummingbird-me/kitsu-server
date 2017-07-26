module ListSync
  module ErrorHandling
    extend ActiveSupport::Concern

    def capture_sync_errors(linked_account, pending_logs)
      yield
    rescue ListSync::NotFoundError
      error! pending_logs, 'No equivalent'
    rescue ListSync::AuthenticationError
      linked_account.update!(sync_to: false, disabled_reason: 'Login failed')
      error! pending_logs, 'Login failed'
    rescue ListSync::RemoteError => e
      error! pending_logs, e.message
      raise
    rescue StandardError
      error! pending_logs, 'Unknown Error'
      raise
    end

    private

    def error!(logs, message)
      changes = { error_message: message, sync_status: :error }
      logs.each { |log| log.update!(changes) }
    end
  end
end

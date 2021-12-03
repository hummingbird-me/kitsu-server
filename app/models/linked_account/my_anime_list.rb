class LinkedAccount
  class MyAnimeList < LinkedAccount
    validate :verify_mal_credentials, if: :token_changed?

    def verify_mal_credentials
      errors.add(:token, 'Username or password was incorrect.') unless list_sync.logged_in?
    end

    def list_sync
      @list_sync ||= ListSync::MyAnimeList.new(self)
    end

    after_commit(on: :create) do
      ListSync::SyncWorker.perform_in(3.minutes, id, user_id) if sync_to?
    end
  end
end

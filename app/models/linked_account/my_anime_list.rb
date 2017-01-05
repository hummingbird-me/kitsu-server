class LinkedAccount
  class MyAnimeList < LinkedAccount
    validate :verify_mal_credentials, if: :sync_to_mal?

    def verify_mal_credentials
      # Check to make sure username/password is valid
      host = MyAnimeListSyncService::ATARASHII_API_HOST
      response = Typhoeus::Request.new(
        "#{host}account/verify_credentials",
        method: :get,
        userpwd: "#{external_user_id}:#{token}"
      ).run

      return true if response.code == 200

      errors.add(:token, "#{response.code}: #{response.body}")
    end

    def sync_to_mal?
      sync_to == true && type == 'LinkedAccount::MyAnimeList'
    end

    after_save do
      MyAnimeListListWorker.perform_async(user_id) if sync_to_mal?
    end
  end
end

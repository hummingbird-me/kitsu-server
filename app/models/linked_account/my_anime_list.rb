class LinkedAccount
  class MyAnimeList < LinkedAccount
    validate :verify_mal_credentials

    def verify_mal_credentials
      # Check to make sure username/password is valid
      host = MyAnimeListSyncService::ATARASHII_API_HOST
      response = Typhoeus::Request.get(
        "#{host}account/verify_credentials",
        userpwd: "#{external_user_id}:#{token}"
      )

      if response.code == 200
        true
      elsif response.code == 403
        errors.add(:token, 'Username or password was incorrect.')
      else
        errors.add(:token, "#{response.code}: #{response.body}")
      end
    end

    after_save do
      MyAnimeListListWorker.perform_async(user_id) if sync_to?
    end
  end
end

# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
#  share_from         :boolean          default(FALSE), not null
#  share_to           :boolean          default(FALSE), not null
#  sync_to            :boolean          default(FALSE), not null
#  type               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_user_id   :string           not null
#  user_id            :integer          not null, indexed
#
# Indexes
#
#  index_linked_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#

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

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  disabled_reason    :string
#  encrypted_token    :string
#  encrypted_token_iv :string
#  session_data       :text
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
# rubocop:enable Metrics/LineLength

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

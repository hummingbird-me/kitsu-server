# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
#  private            :boolean          default(TRUE), not null
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

class LinkedAccount < ApplicationRecord
  belongs_to :user, required: true

  attr_encrypted :token, key: Base64.encode64(ENV['ATTR_ENCRYPT_KEY'])

  # validates_presence_of :url, if: :private?
  validates_presence_of :external_user_id
  validate :verify_mal_credentials, if: :sync_to_mal?

  def verify_mal_credentials
    # Check to make sure username/password is valid
    host = MyAnimeListSyncService::ATARASHII_API_HOST
    response = Typhoeus::Request.new(
      "#{host}account/verify_credentials",
      method: :get,
      userpwd: "#{external_user_id}:#{token}"
    ).run

    unless response.code == 200
      errors.add(:token, "#{response.code}: #{response.body}")
    end

    true
  end

  def sync_to_mal?
    sync_to == true && type == 'LinkedAccount::MyAnimeList'
  end

  after_save do
    MyAnimeListListWorker.perform_async(user_id) if sync_to_mal?
  end
end

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

class LinkedAccount < ApplicationRecord
  belongs_to :user, required: true
  has_many :library_entry_logs, dependent: :destroy
  # encyrpt the token
  attr_encrypted :token, key: Base64.decode64(ENV['ATTR_ENCRYPT_KEY'])
  # expose for jsonapi
  alias_attribute :kind, :type

  validates_presence_of :external_user_id, :type
  validate :type_is_subclass

  def type_is_subclass
    return false unless type

    in_namespace = type.start_with?('LinkedAccount')
    is_descendant = type.safe_constantize <= LinkedAccount
    errors.add(:type, 'must be a LinkedAccount class') unless in_namespace && is_descendant
  end

  def self.without_syncing(reason = nil)
    sync_enabled = where(sync_to: true)
    sync_enabled.update_all(sync_to: false, disabled_reason: reason)
    yield
    sync_enabled.update_all(sync_to: true, disabled_reason: nil)
  end

  def self.disable_syncing_for(user, reason = nil, &block)
    where(user: user).without_syncing(reason, &block)
  end
end

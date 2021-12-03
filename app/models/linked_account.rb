class LinkedAccount < ApplicationRecord
  belongs_to :user
  has_many :library_entry_logs, dependent: :destroy
  # encyrpt the token
  attr_encrypted :token, key: Base64.decode64(ENV['ATTR_ENCRYPT_KEY'])
  # expose for jsonapi
  alias_attribute :kind, :type

  validates_presence_of :external_user_id, :type
  validate :type_is_subclass

  def type_is_subclass
    return false if type.blank?

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

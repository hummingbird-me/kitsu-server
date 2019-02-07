class Types::Session < Types::BaseObject
  description 'Information about a user session'

  field :account, Types::Account,
    null: true,
    description: 'The account associated with this session'

  def account
    object unless object.blank?
  end

  field :profile, Types::Profile,
    null: true,
    description: 'The profile associated with this session'

  def profile
    object unless object.blank?
  end
end

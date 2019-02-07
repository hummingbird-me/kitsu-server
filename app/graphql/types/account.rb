class Types::Account < Types::BaseObject
  description 'A user account on Kitsu'

  field :id, ID, null: false

  field :email, [String],
    null: false,
    description: 'The email addresses associated with this account'

  field :profile, Types::Profile,
    null: false,
    description: 'The profile for this account'

  field :pro_subscription, Types::ProSubscription,
    null: true,
    description: 'The PRO subscription for this account'
end

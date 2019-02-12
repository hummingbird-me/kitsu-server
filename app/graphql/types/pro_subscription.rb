class Types::ProSubscription < Types::BaseObject
  description 'A subscription to Kitsu PRO'

  field :account, Types::Account,
    null: false,
    description: 'The account which is subscribed to Pro benefits'

  field :tier, Types::ProTier,
    null: false,
    description: 'The tier of Pro the account is subscribed to'

  field :billing_service, Types::RecurringBillingService,
    null: false,
    description: 'The billing service used for this subscription'
end

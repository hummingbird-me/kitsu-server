class Types::ProSubscription < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A subscription to Kitsu PRO'

  field :account, Types::Account,
    null: false,
    description: 'The account which is subscribed to Pro benefits'

  field :tier, Types::Enum::ProTier,
    null: false,
    description: 'The tier of Pro the account is subscribed to'

  field :billing_service, Types::Enum::RecurringBillingService,
    null: false,
    description: 'The billing service used for this subscription'
end

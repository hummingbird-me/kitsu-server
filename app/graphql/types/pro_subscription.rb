class Types::ProSubscription < Types::BaseObject
  description 'A subscription to Kitsu PRO'

  field :account, Types::Account,
    null: false,
    description: 'The account which is subscribed to PRO benefits'

  field :plan, Types::ProSubscriptionPlan,
    null: false,
    description: 'The plan this account is subscribed to'

  field :billing_service, Types::RecurringBillingService,
    null: false,
    description: 'The billing service used for this subscription'
end

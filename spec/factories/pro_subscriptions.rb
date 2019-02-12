FactoryBot.define do
  factory :pro_subscription do
    type { 'ProSubscription::StripeSubscription' }
    association :user, strategy: :build
    billing_id { 'test_customer_id' }
    tier { ProSubscription.tiers.keys.sample }
  end
end

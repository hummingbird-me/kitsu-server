FactoryBot.define do
  factory :pro_subscription do
    association :user, strategy: :build
    billing_service :stripe
    billing_id 'test_customer_id'
  end
end

FactoryBot.define do
  factory :group_action_log do
    association :target, factory: :group_invite, strategy: :create
    association :group
    association :user
    verb { Faker::Lorem.word }
  end
end

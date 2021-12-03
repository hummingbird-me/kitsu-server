FactoryBot.define do
  factory :block do
    user
    association :blocked, factory: :user, strategy: :build
  end
end

FactoryBot.define do
  factory :post do
    user
    content { Faker::Lorem.sentence }

    trait :locked do
      association :locked_by, factory: :user, strategy: :build
      locked_at { DateTime.now }
      locked_reason { :spam }
    end
  end
end

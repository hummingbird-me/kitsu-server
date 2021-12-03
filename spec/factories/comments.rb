FactoryBot.define do
  factory :comment do
    association :user, factory: :user, strategy: :build
    association :post, factory: :post, strategy: :build
    content { Faker::Lorem.sentence }
  end
end

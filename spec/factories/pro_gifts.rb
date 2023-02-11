FactoryBot.define do
  factory :pro_gift do
    association :from, factory: :user, strategy: :build
    association :to, factory: :user, strategy: :build
    message { Faker::Lorem.sentences(number: 1) }
  end
end

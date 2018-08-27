FactoryBot.define do
  factory :pro_gift do
    association :from, factory: :user, strategy: :build
    association :to, factory: :user, strategy: :build
    message { Faker::Lorem.paragraph_by_chars(300) }
  end
end

FactoryBot.define do
  factory :ama do
    start_date { Time.now }
    description { { en: Faker::Lorem.sentence } }
    association :author, factory: :user
    association :original_post, factory: :post
  end
end

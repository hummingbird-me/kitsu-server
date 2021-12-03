FactoryBot.define do
  factory :community_recommendation_request do
    user
    description { { en: Faker::Lorem.sentence } }
    title { Faker::Name.name }
  end
end

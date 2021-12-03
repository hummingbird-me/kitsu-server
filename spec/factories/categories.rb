FactoryBot.define do
  factory :category do
    title { Faker::Name.name }
    description { { en: Faker::Lorem.sentence } }
  end
end

FactoryBot.define do
  factory :group_category do
    name { Faker::Lorem.word }
    description { { en: Faker::Lorem.sentence } }
  end
end

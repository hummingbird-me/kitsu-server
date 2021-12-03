FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    names { { en: Faker::Name.name } }
    canonical_name { 'en' }
    description { { en: Faker::Lorem.sentence } }
  end
end

FactoryBot.define do
  factory :character do
    name { Faker::Name.name }
    association :primary_media, factory: :anime
    description { { en: Faker::Lorem.sentence } }
  end
end

FactoryBot.define do
  factory :genre do
    # TODO: switch to Faker::Book.genre when they make a new release
    name { Faker::Book.genre }
    description { { en: Faker::Lorem.sentence } }
  end
end

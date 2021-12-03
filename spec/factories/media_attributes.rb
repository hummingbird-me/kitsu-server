FactoryBot.define do
  factory :media_attribute do
    title { Faker::Name.name }
    high_title { Faker::Name.name }
    neutral_title { Faker::Name.name }
    low_title { Faker::Name.name }
  end
end

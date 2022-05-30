FactoryBot.define do
  factory :site_announcement do
    association :user, strategy: :build
    title { Faker::Lorem.sentence }
    description { { en: Faker::Lorem.sentence(word_count: 3) } }
    image_url { Faker::LoremPixel.image }
    link { Faker::Internet.url }
  end
end

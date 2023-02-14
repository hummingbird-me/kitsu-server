FactoryBot.define do
  factory :site_announcement do
    association :user, strategy: :build
    title { Faker::Lorem.sentence(word_count: 5) }
    description { { en: Faker::Lorem.sentences(number: 2) } }
    image_url { Faker::LoremPixel.image }
    link { Faker::Internet.url }
  end
end

FactoryBot.define do
  factory :episode do
    association :media, factory: :anime, strategy: :build
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    description { { en: Faker::Lorem.paragraph(sentence_count: 4) } }
    length { rand(20..60) }
    airdate { Faker::Date.between(from: 20.years.ago, to: Date.today) }
    season_number { 1 }
    sequence(:number)

    factory :drama_episode do
      association :media, factory: :drama, strategy: :build
    end
  end
end

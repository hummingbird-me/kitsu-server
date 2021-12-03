FactoryBot.define do
  factory :episode do
    association :media, factory: :anime, strategy: :build
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    description { { en: Faker::Lorem.paragraph(4) } }
    length { rand(20..60) }
    airdate { Faker::Date.between(20.years.ago, Date.today) }
    season_number { 1 }
    sequence(:number)

    factory :drama_episode do
      association :media, factory: :drama, strategy: :build
    end
  end
end

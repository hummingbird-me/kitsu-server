FactoryBot.define do
  factory :drama do
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    average_rating { rand(1.0..100.0) }
    age_rating { 'G' }

    trait :nsfw do
      age_rating { 'R18' }
    end
  end
end

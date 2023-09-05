# frozen_string_literal: true

FactoryBot.define do
  factory :anime do
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    average_rating { rand(1.0..100.0) }
    subtype { Anime.subtypes.keys.sample }
    age_rating { 'G' }
    episode_length { 24 }
    start_date { Faker::Date.backward(days: 10_000) }
    description { { 'en' => Faker::Lorem.paragraph } }

    trait :nsfw do
      age_rating { 'R18' }
    end

    trait :categories do
      transient do
        amount { 5 }
      end

      after(:create) do |anime, evaluator|
        anime.categories = create_list(:category, evaluator.amount)
      end
    end

    trait :with_episodes do
      after(:create) do |anime|
        anime.episodes = create_list(:episode, anime.episode_count, length: anime.episode_length)
      end
    end
  end
end

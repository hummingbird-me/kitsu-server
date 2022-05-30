FactoryBot.define do
  factory :manga do
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    average_rating { rand(1.0..100.0) }
    start_date { Faker::Date.backward(days: 10_000) }

    trait :categories do
      transient do
        amount { 5 }
      end

      after(:create) do |manga, evaluator|
        manga.categories = create_list(:category, evaluator.amount)
      end
    end
  end
end

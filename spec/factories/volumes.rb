FactoryBot.define do
  factory :volume do
    association :manga, factory: :manga
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    sequence(:number)
  end
end

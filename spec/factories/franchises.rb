FactoryBot.define do
  factory :franchise do
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
  end
end

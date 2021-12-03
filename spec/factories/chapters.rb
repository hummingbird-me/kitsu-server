FactoryBot.define do
  factory :chapter do
    association :manga, factory: :manga
    association :volume, factory: :volume
    titles { { en_jp: Faker::Name.name } }
    canonical_title { 'en_jp' }
    description { { en: Faker::Lorem.paragraph(4) } }
    length { rand(20..60) }
    published { Faker::Date.between(20.years.ago, Date.today) }
    volume_number { rand(1..10) }
    sequence(:number)
  end
end

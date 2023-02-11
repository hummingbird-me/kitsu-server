FactoryBot.define do
  factory :review do
    content { Faker::Lorem.paragraphs(number: 2) }
    association :library_entry, factory: :library_entry, rating: 3.0,
      strategy: :build
    association :user, factory: :user, strategy: :build
    association :media, factory: :anime, strategy: :build
  end
end

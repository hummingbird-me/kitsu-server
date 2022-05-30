FactoryBot.define do
  factory :media_reaction do
    reaction { Faker::Lorem.characters(number: 140) }
    association :anime, factory: :anime, strategy: :build
    association :library_entry, factory: :library_entry,
                                progress: 1, strategy: :build
    association :user, factory: :user, strategy: :build
  end
end

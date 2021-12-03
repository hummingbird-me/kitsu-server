FactoryBot.define do
  factory :library_entry do
    association :media, factory: :anime
    association :user, strategy: :build
    status { 'planned' }
    progress { 0 }
    time_spent { progress * 24 }

    trait :nsfw do
      association :media, :nsfw, factory: :anime, strategy: :build
    end
    trait :with_rating do
      rating { rand(1..19) }
    end
  end
end

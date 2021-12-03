FactoryBot.define do
  factory :library_event do
    association :library_entry, strategy: :build
    association :user, strategy: :build

    kind { :updated }

    trait :with_anime do
      anime_id { 1 }
    end

    trait :with_manga do
      manga_id { 1 }
    end
  end
end

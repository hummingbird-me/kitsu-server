FactoryBot.define do
  factory :category_favorite do
    association :user, factory: :user, strategy: :build
    association :category, factory: :category, strategy: :build
  end
end

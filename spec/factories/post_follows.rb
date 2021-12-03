FactoryBot.define do
  factory :post_follow do
    association :user, factory: :user, strategy: :build
    association :post, factory: :post, strategy: :build
  end
end

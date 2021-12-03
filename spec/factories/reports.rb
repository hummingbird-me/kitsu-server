FactoryBot.define do
  factory :report do
    association :naughty, factory: :post, strategy: :build
    association :user, factory: :user, strategy: :build
    reason { :nsfw }
  end
end

FactoryBot.define do
  factory :group_report do
    association :group, factory: :group, strategy: :build
    association :naughty, factory: :post, strategy: :build
    association :user, factory: :user, strategy: :build
    reason { :nsfw }
  end
end

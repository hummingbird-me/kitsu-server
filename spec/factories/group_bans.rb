FactoryBot.define do
  factory :group_ban do
    association :group, strategy: :build
    association :user, strategy: :build
    association :moderator, strategy: :build, factory: :user
  end
end

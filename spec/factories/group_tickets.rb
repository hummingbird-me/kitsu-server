FactoryBot.define do
  factory :group_ticket do
    association :group, strategy: :build
    association :user, strategy: :build
  end
end

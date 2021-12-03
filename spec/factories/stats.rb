FactoryBot.define do
  factory :stat do
    association :user, factory: :user, strategy: :build
    type { 'Stat::AnimeCategoryBreakdown' }
  end
end

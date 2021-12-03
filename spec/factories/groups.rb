FactoryBot.define do
  factory :group do
    name { Faker::University.name }
    association :category, factory: :group_category, strategy: :build
  end
end

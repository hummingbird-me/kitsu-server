FactoryBot.define do
  factory :group_neighbor do
    association :source, factory: :group
    association :destination, factory: :group
  end
end

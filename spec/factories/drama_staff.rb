FactoryBot.define do
  factory :drama_staff do
    association :drama, factory: :drama, strategy: :build
    association :person, factory: :person, strategy: :build
  end
end

FactoryBot.define do
  factory :drama_character do
    association :drama, factory: :drama, strategy: :build
    association :character, factory: :character, strategy: :build
  end
end

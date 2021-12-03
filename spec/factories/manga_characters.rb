FactoryBot.define do
  factory :manga_character do
    association :manga, factory: :manga, strategy: :build
    association :character, factory: :character, strategy: :build
  end
end

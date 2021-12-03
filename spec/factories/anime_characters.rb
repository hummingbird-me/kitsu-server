FactoryBot.define do
  factory :anime_character do
    association :anime, factory: :anime, strategy: :build
    association :character, factory: :character, strategy: :build
  end
end

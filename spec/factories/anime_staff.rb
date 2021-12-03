FactoryBot.define do
  factory :anime_staff do
    association :anime, factory: :anime, strategy: :build
    association :person, factory: :person, strategy: :build
  end
end

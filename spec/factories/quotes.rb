FactoryGirl.define do
  factory :quote do
    association :user, factory: :user, strategy: :build
    association :media, factory: :anime, strategy: :build
    association :character, factory: :character, strategy: :build

    content { Faker::Lorem.sentence }
  end
end

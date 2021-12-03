FactoryBot.define do
  factory :quote do
    association :user, factory: :user, strategy: :build
    association :media, factory: :anime, strategy: :build
  end
end

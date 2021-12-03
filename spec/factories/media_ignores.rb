FactoryBot.define do
  factory :media_ignore do
    association :media, factory: :anime, strategy: :build
    association :user, factory: :user, strategy: :build
  end
end

FactoryBot.define do
  factory :casting do
    association :media, factory: :anime, strategy: :build
    character
  end
end

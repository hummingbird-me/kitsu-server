FactoryBot.define do
  factory :favorite do
    association :item, factory: :anime, strategy: :build
    user
  end
end

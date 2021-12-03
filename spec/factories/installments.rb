FactoryBot.define do
  factory :installment do
    association :media, factory: :anime, strategy: :build
    franchise
  end
end

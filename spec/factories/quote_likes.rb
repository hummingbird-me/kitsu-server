FactoryBot.define do
  factory :quote_like do
    association :user
    association :quote
  end
end

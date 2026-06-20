FactoryBot.define do
  factory :post do
    association :user
    
    sequence(:title) { |n| "Hello#{n}" }
  end
end

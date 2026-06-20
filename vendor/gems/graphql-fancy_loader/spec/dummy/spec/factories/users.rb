FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "fake@fake#{n}.com" }
  end
end

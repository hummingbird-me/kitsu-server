FactoryBot.define do
  factory :leader_chat_message do
    association :user, strategy: :build
    association :group, strategy: :build
    content { Faker::Lorem.sentence }
  end
end

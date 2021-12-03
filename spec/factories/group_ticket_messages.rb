FactoryBot.define do
  factory :group_ticket_message do
    association :ticket, strategy: :build, factory: :group_ticket
    association :user, strategy: :build
    content { Faker::Lorem.sentence }
  end
end

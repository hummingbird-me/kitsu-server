FactoryBot.define do
  factory :group_permission do
    group_member
    permission { 1 }
  end
end

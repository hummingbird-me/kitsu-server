FactoryBot.define do
  factory :pro_membership_plan do
    recurring { [true, false].sample }
    duration { rand(1..35) }
    amount { rand(500..9999) }
    name { Faker::App.name }

    factory :nonrecurring_pro_membership_plan do
      recurring { false }
    end
    factory :recurring_pro_membership_plan do
      recurring { true }
    end
  end
end

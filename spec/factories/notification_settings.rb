FactoryBot.define do
  factory :notification_setting do
    user
    setting_type { rand(0..4) }
  end
end

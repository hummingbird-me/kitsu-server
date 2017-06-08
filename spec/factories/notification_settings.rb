# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: notification_settings
#
#  id           :integer          not null, primary key
#  setting_name :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :notification_setting do
    setting_name { Faker::Name.name }
  end
end

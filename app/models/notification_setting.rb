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

class NotificationSetting < ActiveRecord::Base
  has_many :notification_setting_states

  validates :setting_name, presence: true
end

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

require 'rails_helper'

RSpec.describe NotificationSetting, type: :model do
  subject { build(:notification_setting) }

  it { should validate_presence_of(:setting_name) }
end

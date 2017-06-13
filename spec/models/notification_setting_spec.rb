# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: notification_settings
#
#  id                      :integer          not null, primary key
#  is_email_toggled        :boolean          default(TRUE)
#  is_fb_messenger_toggled :boolean          default(TRUE)
#  is_mobile_toggled       :boolean          default(TRUE)
#  is_web_toggled          :boolean          default(TRUE)
#  setting_type            :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null, indexed
#
# Indexes
#
#  index_notification_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_0c95e91db7  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe NotificationSetting, type: :model do
  subject { build(:notification_setting) }

  it { should belong_to(:user) }
end

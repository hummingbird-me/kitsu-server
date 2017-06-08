# == Schema Information
#
# Table name: notification_setting_states
#
#  id                      :integer          not null, primary key
#  is_toggled              :boolean          default(TRUE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  notification_setting_id :integer          not null, indexed
#  user_id                 :integer          not null, indexed
#
# Indexes
#
#  index_notification_setting_states_on_notification_setting_id
#                                         (notification_setting_id)
#  index_notification_setting_states_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_057c83c713  (user_id => users.id)
#  fk_rails_66e9ee5396  (notification_setting_id => notification_settings.id)
#

require 'rails_helper'

RSpec.describe NotificationSettingState, type: :model do
  subject { build(:notification_setting_state) }

  it { should belong_to(:user) }
  it { should belong_to(:notification_setting) }
end

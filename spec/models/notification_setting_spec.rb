require 'rails_helper'

RSpec.describe NotificationSetting, type: :model do
  subject { build(:notification_setting) }

  it { is_expected.to belong_to(:user).required }
end

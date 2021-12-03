require 'rails_helper'

RSpec.describe NotificationSetting, type: :model do
  subject { build(:notification_setting) }

  it { should belong_to(:user).required }
end

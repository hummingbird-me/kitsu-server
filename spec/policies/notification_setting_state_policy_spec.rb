require 'rails_helper'

RSpec.describe NotificationSettingStatePolicy do
  let(:user) { token_for build(:user) }
  let(:setting) do
    build(:notification_setting_state, user: user.resource_owner)
  end
  let(:other) { build(:notification_setting_state) }
  subject { described_class }

  permissions :update? do
    it('should allow users') { should permit(user, setting) }
    it('should not allow anons') { should_not permit(nil, setting) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, setting) }
    it('should not allow for yourself') { should_not permit(user, setting) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end

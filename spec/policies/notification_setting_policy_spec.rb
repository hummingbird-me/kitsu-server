require 'rails_helper'

RSpec.describe NotificationSettingPolicy do
  let(:user) { token_for build(:user) }
  let(:setting) { build(:notification_setting, user: user.resource_owner) }
  let(:other) { build(:notification_setting) }
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

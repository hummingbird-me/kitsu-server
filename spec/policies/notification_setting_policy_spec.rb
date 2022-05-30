require 'rails_helper'

RSpec.describe NotificationSettingPolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:setting) { build(:notification_setting, user: user.resource_owner) }
  let(:other) { build(:notification_setting) }

  permissions :update? do
    it('allows users') { is_expected.to permit(user, setting) }
    it('does not allow anons') { is_expected.not_to permit(nil, setting) }
  end

  permissions :create?, :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, setting) }
    it('does not allow for yourself') { is_expected.not_to permit(user, setting) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end
end

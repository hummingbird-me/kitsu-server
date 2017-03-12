require 'rails_helper'

RSpec.describe GroupUnreadFanoutService do
  describe '#run!' do
    it 'should increment unread_count on the members' do
      member = create(:group_member)
      group = member.group
      source_user = create(:user)

      expect {
        described_class.new(group, source_user).run!
      }.to change { member.reload.unread_count }.by(1)
    end
  end
end

require 'rails_helper'

RSpec.describe GroupUnreadFanoutService do
  describe '#run!' do
    it 'should increment unread_count on the members' do
      member = create(:group_member)
      group = member.group

      expect {
        described_class.new(group).run!
      }.to change { member.reload.unread_count }.by(1)
    end
  end
end

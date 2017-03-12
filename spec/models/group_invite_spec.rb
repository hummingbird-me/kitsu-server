# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_invites
#
#  id          :integer          not null, primary key
#  accepted_at :datetime
#  declined_at :datetime
#  revoked_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  group_id    :integer          not null, indexed
#  sender_id   :integer          not null, indexed
#  user_id     :integer          not null, indexed
#
# Indexes
#
#  index_group_invites_on_group_id   (group_id)
#  index_group_invites_on_sender_id  (sender_id)
#  index_group_invites_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_62774fb6d2  (sender_id => users.id)
#  fk_rails_7255dc4343  (group_id => groups.id)
#  fk_rails_d969f0761c  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupInvite, type: :model do
  it { should belong_to(:group) }
  it { should validate_presence_of(:group) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:sender).class_name('User') }
  it { should validate_presence_of(:sender) }

  it 'should limit to one active invite per user per group' do
    invite = create(:group_invite)
    second_invite = build(:group_invite, group: invite.group, user: invite.user)
    expect(second_invite).to be_invalid
    expect(second_invite.errors[:user]).not_to be_empty
  end

  it 'should prevent you from inviting yourself' do
    user = build(:user)
    invite = build(:group_invite, user: user, sender: user)
    expect(invite).to be_invalid
    expect(invite.errors[:user]).not_to be_empty
  end
end

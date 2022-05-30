require 'rails_helper'

RSpec.describe GroupInvite, type: :model do
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:sender).class_name('User').required }

  it 'limits to one active invite per user per group' do
    invite = create(:group_invite)
    second_invite = build(:group_invite, group: invite.group, user: invite.user)
    expect(second_invite).to be_invalid
    expect(second_invite.errors[:user]).not_to be_empty
  end

  it 'prevents you from inviting yourself' do
    user = build(:user)
    invite = build(:group_invite, user: user, sender: user)
    expect(invite).to be_invalid
    expect(invite.errors[:user]).not_to be_empty
  end
end

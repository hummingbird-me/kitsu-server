require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  subject { build(:group_member) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:group).counter_cache('members_count').required }
  it { is_expected.to have_many(:permissions).dependent(:destroy) }
  it { is_expected.to have_many(:notes).dependent(:destroy) }
  it { is_expected.to define_enum_for(:rank) }

  it 'sends the follow to Stream on save' do
    subject.user.save!
    subject.group.save!
    expect(subject.user.timeline).to receive(:follow).with(subject.group.feed)
    subject.save!
  end

  it 'removes the follow from Stream on save' do
    subject.save!
    expect(subject.user.timeline).to receive(:unfollow).with(subject.group.feed)
    subject.destroy!
  end
end

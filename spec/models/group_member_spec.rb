require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  subject { build(:group_member) }

  it { should belong_to(:user).required }
  it { should belong_to(:group).counter_cache('members_count').required }
  it { should have_many(:permissions).dependent(:destroy) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should define_enum_for(:rank) }

  it 'should send the follow to Stream on save' do
    subject.user.save!
    subject.group.save!
    expect(subject.user.timeline).to receive(:follow).with(subject.group.feed)
    subject.save!
  end

  it 'should remove the follow from Stream on save' do
    subject.save!
    expect(subject.user.timeline).to receive(:unfollow).with(subject.group.feed)
    subject.destroy!
  end
end

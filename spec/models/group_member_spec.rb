# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_members
#
#  id           :integer          not null, primary key
#  hidden       :boolean          default(FALSE), not null
#  rank         :integer          default(0), not null, indexed
#  unread_count :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  group_id     :integer          not null, indexed, indexed => [user_id]
#  user_id      :integer          not null, indexed, indexed => [group_id]
#
# Indexes
#
#  index_group_members_on_group_id              (group_id)
#  index_group_members_on_rank                  (rank)
#  index_group_members_on_user_id               (user_id)
#  index_group_members_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupMember, type: :model do
  subject { build(:group_member) }

  it { should belong_to(:user) }
  it { should belong_to(:group).counter_cache('members_count') }
  it { should have_many(:permissions).dependent(:destroy) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should define_enum_for(:rank) }

  it 'should send the follow to Stream on save' do
    expect(subject.user.timeline).to receive(:follow).with(subject.group.feed)
    subject.save!
  end

  it 'should remove the follow from Stream on save' do
    subject.save!
    expect(subject.user.timeline).to receive(:unfollow).with(subject.group.feed)
    subject.destroy!
  end
end

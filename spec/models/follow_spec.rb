# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          indexed => [follower_id]
#  follower_id :integer          indexed, indexed => [followed_id]
#
# Indexes
#
#  index_follows_on_followed_id                  (follower_id)
#  index_follows_on_followed_id_and_follower_id  (followed_id,follower_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Follow, type: :model do
  subject { build(:follow) }
  it { should belong_to(:follower).class_name('User')
    .counter_cache(:following_count).touch(true) }
  it { should validate_presence_of(:follower) }
  it { should belong_to(:followed).class_name('User')
    .counter_cache(:followers_count).touch(true) }
  it { should validate_presence_of(:followed) }

  it "should add follow to follower's feed on save" do
    expect(subject.follower.feed).to receive(:follow)
      .with(subject.followed.feed)
    subject.save!
  end

  it "should remove follow on follwer's feed on destroy" do
    subject.save!
    expect(subject.follower.feed).to receive(:unfollow)
      .with(subject.followed.feed)
    subject.destroy!
  end

  it 'should not permit you to follow yourself' do
    user = build(:user)
    follow = build(:follow, follower: user, followed: user)
    follow.valid?
    expect(follow.errors[:followed]).to include('cannot follow yourself')
  end

  it "should generate an activity on the followers' aggregated feed" do
    follower_feed = subject.follower.aggregated_feed
    expect(subject.stream_activity.feed).to eq(follower_feed)
  end
end

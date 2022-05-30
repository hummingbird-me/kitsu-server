require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { build(:post, content: nil) }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:target_user).class_name('User').optional }
  it { is_expected.to belong_to(:media).optional }
  it { is_expected.to belong_to(:spoiled_unit).optional }
  it { is_expected.to belong_to(:locked_by).class_name('User').optional }
  it { is_expected.to have_many(:post_likes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to validate_length_of(:content).is_at_most(9_000) }
  it { is_expected.to have_many(:reposts).dependent(:delete_all) }

  context 'with content' do
    before { post.content = 'some content' }

    it { is_expected.not_to validate_presence_of(:uploads).with_message('must exist') }
  end

  context 'with uploads' do
    before do
      post.uploads = [build(:upload)]
      post.content = nil
    end

    it { is_expected.not_to validate_presence_of(:content) }
  end

  context 'with a spoiled unit' do
    subject(:post) { build(:post, spoiled_unit: build(:episode)) }

    it { is_expected.to validate_presence_of(:media) }
    it { is_expected.to allow_value(true).for(:spoiler) }
  end

  context 'with a media' do
    subject(:post) { build(:post, media: media) }

    let(:media) { create(:anime) }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    it 'has an activity with media feed in "to" list' do
      expect(activity[:to]).to include("media:Anime-#{media.id}")
    end
  end

  it 'converts basic markdown to fill in content_formatted' do
    post = create(:post, content: '*Emphasis* is cool!')
    expect(post.content_formatted).to include('<em>')
  end

  context 'with an @mention' do
    subject(:post) { build(:post, content: '@thisisatest') }

    let!(:user) { create(:user, slug: 'thisisatest') }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    describe '#stream_activity' do
      it "has the mentioned user's notifications in the to field" do
        notifications_feed = user.notifications.read_target.join(':')
        expect(activity[:to]).to include(notifications_feed)
      end
    end
  end

  context 'with a target user' do
    subject(:post) { build(:post, target_user: user) }

    let(:user) { create(:user) }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    describe '#stream_activity' do
      it "has the target user's feed as the target" do
        expect(post.stream_activity.feed).to eq(user.profile_feed)
      end

      it "has the target user's notifications in the to field" do
        notifications_feed = user.notifications.read_target.join(':')
        expect(activity[:to]).to include(notifications_feed)
      end
    end
  end

  context 'with a target group' do
    subject(:post) { build(:post, target_group: group) }

    let(:group) { create(:group) }

    describe '#stream_activity' do
      it "has the group's feed as the target" do
        expect(post.stream_activity.feed).to eq(group.feed)
      end
    end

    context 'which is NSFW' do
      before { group.nsfw = true }

      it 'automatically marks the post NSFW before save' do
        post.save!
        expect(post.nsfw).to be(true)
      end
    end
  end

  it 'does not allow target_group and target_user to coexist' do
    group = build(:group)
    user = build(:user)
    post = build(:post, target_group: group, target_user: user)
    post.valid?
    expect(post.errors).to include(:target_group, :target_user)
  end
end

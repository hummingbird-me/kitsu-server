# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: posts
#
#  id                       :integer          not null, primary key
#  blocked                  :boolean          default(FALSE), not null
#  comments_count           :integer          default(0), not null
#  content                  :text             not null
#  content_formatted        :text             not null
#  deleted_at               :datetime         indexed
#  edited_at                :datetime
#  media_type               :string
#  nsfw                     :boolean          default(FALSE), not null
#  post_likes_count         :integer          default(0), not null
#  spoiled_unit_type        :string
#  spoiler                  :boolean          default(FALSE), not null
#  top_level_comments_count :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  media_id                 :integer
#  spoiled_unit_id          :integer
#  target_group_id          :integer
#  target_user_id           :integer
#  user_id                  :integer          not null
#
# Indexes
#
#  index_posts_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_43023491e6  (target_user_id => users.id)
#  fk_rails_5b5ddfd518  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:target_user).class_name('User') }
  it { should validate_presence_of(:content) }
  it { should belong_to(:media) }
  it { should belong_to(:spoiled_unit) }
  it { should have_many(:post_likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_length_of(:content).is_at_most(9_000) }

  context 'with a spoiled unit' do
    subject { build(:post, spoiled_unit: build(:episode)) }
    it { should validate_presence_of(:media) }
    it { should allow_value(true).for(:spoiler) }
    it { should_not allow_value(false).for(:spoiler) }
  end

  context 'with a media' do
    let(:media) { create(:anime) }
    subject { build(:post, media: media) }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    it 'should have an activity with media\'s posts feed in "to" list' do
      expect(activity[:to]).to include(media.posts_feed.stream_id)
    end
  end

  it 'should convert basic markdown to fill in content_formatted' do
    post = create(:post, content: '*Emphasis* is cool!')
    expect(post.content_formatted).to include('<em>')
  end

  context 'with an @mention' do
    let!(:user) { create(:user) }
    subject { build(:post, content: "@#{user.name}") }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    describe '#stream_activity' do
      it "should have the mentioned user's notifications in the to field" do
        expect(activity[:to]).to include(user.notifications.stream_id)
      end
    end
  end

  context 'with a target user' do
    let(:user) { create(:user) }
    subject { build(:post, target_user: user) }
    let(:activity) { subject.stream_activity.as_json.with_indifferent_access }

    describe '#stream_activity' do
      it "should have the target user's aggregated posts feed as the target" do
        expect(subject.stream_activity.feed).to eq(user.posts_aggregated_feed)
      end

      it "should have the target user's notifications in the to field" do
        expect(activity[:to]).to include(user.notifications.stream_id)
      end
    end
  end

  context 'with a target group' do
    let(:group) { create(:group) }
    subject { build(:post, target_group: group) }

    describe '#stream_activity' do
      it "should have the group's feed as the target" do
        expect(subject.stream_activity.feed).to eq(group.feed)
      end
    end

    context 'which is NSFW' do
      before { group.nsfw = true }

      it 'should automatically be marked NSFW before save' do
        subject.save!
        expect(subject.nsfw).to eq(true)
      end
    end

    it { should validate_absence_of(:target_user) }
  end
end

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  birthday                    :date
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  country                     :string(2)
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_processing      :boolean
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  favorites_count             :integer          default(0), not null
#  feed_completed              :boolean          default(FALSE), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  ip_addresses                :inet             default([]), is an Array
#  language                    :string
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  life_spent_on_anime         :integer          default(0), not null
#  likes_given_count           :integer          default(0), not null
#  likes_received_count        :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  password_digest             :string(255)      default(""), not null
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  previous_email              :string
#  pro_expires_at              :datetime
#  profile_completed           :boolean          default(FALSE), not null
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  share_to_global             :boolean          default(TRUE), not null
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  time_zone                   :string
#  title                       :string
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
#  pinned_post_id              :integer
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  twitter_id                  :string
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#  index_users_on_to_follow    (to_follow)
#  index_users_on_waifu_id     (waifu_id)
#
# Foreign Keys
#
#  fk_rails_bc615464bf  (pinned_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user, id: 1) }
  let(:persisted_user) { create(:user) }

  it { should have_db_index(:facebook_id) }
  it { should belong_to(:waifu) }
  it { should have_many(:linked_accounts).dependent(:destroy) }
  it { should have_many(:profile_links).dependent(:destroy) }
  it { should have_many(:stats).dependent(:destroy) }
  it { should belong_to(:pro_membership_plan) }
  it { should have_many(:followers).dependent(:destroy) }
  it { should have_many(:following).dependent(:destroy) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe 'by_name scope' do
    it 'should match case-insensitively' do
      u = User.by_name(persisted_user.name).first
      expect(u).to eq(persisted_user)
    end
  end

  it 'should reserve certain names case-insensitively' do
    user = User.new(name: 'admin')
    expect(user).to be_invalid
    expect(user.errors[:name]).not_to be_empty
  end

  describe 'find_for_auth' do
    it 'should be able to query by username' do
      u = User.find_for_auth(persisted_user.name)
      expect(u).to eq(persisted_user)
    end
    it 'should be able to query by email' do
      u = User.find_for_auth(persisted_user.email)
      expect(u).to eq(persisted_user)
    end
  end

  describe '#pro?' do
    it 'should return false if the user has no pro expiry' do
      user = build(:user, pro_expires_at: nil)
      expect(user).not_to be_pro
    end
    it 'should return false if the user has already run out of pro' do
      user = build(:user, pro_expires_at: 2.months.ago)
      expect(user).not_to be_pro
    end
    it 'should return true if the user still has pro left' do
      user = build(:user, pro_expires_at: 2.months.from_now)
      expect(user).to be_pro
    end
  end

  describe 'past_names' do
    subject { create(:user) }
    context 'when the user changes name for the first time' do
      it 'should include the old name' do
        old_name = subject.name
        subject.name = 'MisakaMikoto'
        subject.save!
        expect(subject.past_names).to include(old_name)
      end
    end
    it 'should push onto the front when user changes name multiple times' do
      expect {
        3.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.by(3)
    end
    it 'should limit to 10 in length' do
      expect {
        20.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(10)
    end
    it 'should remove duplicate names' do
      expect {
        10.times do
          subject.name = 'MisakaMikoto'
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(1)
    end
    it 'should return first in list when previous_name is called' do
      3.times do |i|
        subject.name = "Misaka100#{i}"
        subject.save
      end
      expect(subject.past_names[0]).to equal(subject.previous_name)
    end
  end

  describe 'available feeds' do
    it 'include a user posts feed' do
      expect(subject.posts_feed).to eq(Feed.user_posts(subject.id))
    end

    it 'include a user media feed' do
      expect(subject.media_feed).to eq(Feed.user_media(subject.id))
    end

    it 'include a user aggregated feed' do
      expect(subject.aggregated_feed).to eq(Feed.user_aggr(subject.id))
    end

    it 'include a user posts aggregated feed' do
      expect(subject.posts_aggregated_feed)
        .to eq(Feed.user_posts_aggr(subject.id))
    end

    it 'include a user media aggregated feed' do
      expect(subject.media_aggregated_feed)
        .to eq(Feed.user_media_aggr(subject.id))
    end

    it 'include a timeline feed' do
      expect(subject.timeline).to eq(Feed.timeline(subject.id))
    end

    it 'include a posts timeline feed' do
      expect(subject.posts_timeline).to eq(Feed.timeline_posts(subject.id))
    end

    it 'include a media timeline feed' do
      expect(subject.media_timeline).to eq(Feed.timeline_media(subject.id))
    end

    it 'include a notifications feed' do
      expect(subject.notifications).to eq(Feed.notifications(subject.id))
    end
  end

  describe 'after creation' do
    before do
      allow_any_instance_of(Feed).to receive(:follow)
      allow_any_instance_of(Feed).to receive(:unfollow)
    end

    context 'setting up the aggregated feed follows' do
      let(:aggregated_feed) { double(:feed).as_null_object }

      before do
        allow(subject).to receive(:aggregated_feed).and_return(aggregated_feed)
      end

      it 'sets user aggregated feed to follow the user posts feed' do
        expect(subject.aggregated_feed)
          .to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets user aggregated feed to follow the user media feed' do
        expect(subject.aggregated_feed)
          .to receive(:follow).with(subject.media_feed)
        subject.save!
      end
    end

    it 'sets user posts aggregated feed to follow the user posts feed' do
      expect(subject.posts_aggregated_feed).to receive(:follow)
        .with(subject.posts_feed)
      subject.save!
    end

    it 'sets user media aggregated feed to follow the user media feed' do
      expect(subject.media_aggregated_feed).to receive(:follow)
        .with(subject.media_feed)
      subject.save!
    end

    context 'setting up the timeline follows' do
      let(:timeline) { double(:feed).as_null_object }

      before do
        allow(subject).to receive(:timeline).and_return(timeline)
      end

      it 'sets the timeline feed to follow the user posts feed' do
        expect(subject.timeline).to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets the timeline feed to follow the user media feed' do
        expect(subject.timeline).to receive(:follow).with(subject.media_feed)
        subject.save!
      end
    end

    it 'sets the posts timeline feed to follow the user posts feed' do
      expect(subject.posts_timeline).to receive(:follow)
        .with(subject.posts_feed)
      subject.save!
    end

    it 'sets the media timeline feed to follow the user media feed' do
      expect(subject.media_timeline).to receive(:follow)
        .with(subject.media_feed)
      subject.save!
    end

    context 'setting up global feeds' do
      let(:global) { double(:feed).as_null_object }
      let(:global_posts) { double(:feed).as_null_object }
      let(:global_media) { double(:feed).as_null_object }

      before do
        allow(Feed).to receive(:global).and_return(global)
        allow(Feed).to receive(:global_posts).and_return(global_posts)
        allow(Feed).to receive(:global_media).and_return(global_media)
      end

      it 'sets the global feed to follow the user posts feed' do
        expect(global).to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets the global feed to follow the user media feed' do
        expect(global).to receive(:follow).with(subject.media_feed)
        subject.save!
      end

      it 'sets the global posts feed to follow the user posts feed' do
        expect(global_posts).to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets the global media feed to follow the user media feed' do
        expect(global_media).to receive(:follow).with(subject.media_feed)
        subject.save!
      end
    end
  end

  describe 'after updating' do
    let(:global) { double(:feed).as_null_object }
    let(:global_posts) { double(:feed).as_null_object }
    let(:global_media) { double(:feed).as_null_object }

    before do
      allow(Feed).to receive(:global).and_return(global)
      allow(Feed).to receive(:global_posts).and_return(global_posts)
      allow(Feed).to receive(:global_media).and_return(global_media)
    end

    context 'when global sharing changes to true' do
      before do
        subject.share_to_global = false
        subject.save!
        subject.share_to_global = true
      end

      it 'sets the global feed to follow the user posts feed' do
        expect(global).to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets the global feed to follow the user media feed' do
        expect(global).to receive(:follow).with(subject.media_feed)
        subject.save!
      end

      it 'sets the global posts feed to follow the user posts feed' do
        expect(global_posts).to receive(:follow).with(subject.posts_feed)
        subject.save!
      end

      it 'sets the global media feed to follow the user media feed' do
        expect(global_media).to receive(:follow).with(subject.media_feed)
        subject.save!
      end
    end

    context 'when global sharing changes to false' do
      before do
        subject.share_to_global = true
        subject.save!
        subject.share_to_global = false
      end

      it 'unsets the global feed from following the user posts feed' do
        expect(global).to receive(:unfollow).with(subject.posts_feed)
        subject.save!
      end

      it 'unsets the global feed from following the user media feed' do
        expect(global).to receive(:unfollow).with(subject.media_feed)
        subject.save!
      end

      it 'unsets the global posts feed from following the user posts feed' do
        expect(global_posts).to receive(:unfollow).with(subject.posts_feed)
        subject.save!
      end

      it 'unsets the global media feed from following the user media feed' do
        expect(global_media).to receive(:unfollow).with(subject.media_feed)
        subject.save!
      end
    end
  end
end

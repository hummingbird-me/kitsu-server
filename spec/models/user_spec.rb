# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  let(:persisted_user) { create(:user) }

  it { is_expected.to have_db_index(:facebook_id) }
  it { is_expected.to belong_to(:waifu).optional }
  it { is_expected.to have_many(:linked_accounts) }
  it { is_expected.to have_many(:profile_links) }
  it { is_expected.to have_many(:stats) }
  it { is_expected.to have_many(:followers) }
  it { is_expected.to have_many(:following) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive.allow_nil }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to have_many(:library_events) }
  it { is_expected.to have_many(:notification_settings) }
  it { is_expected.to have_many(:reposts).dependent(:destroy) }

  context 'for an unregistered user' do
    subject { build(:user, :unregistered) }

    it { is_expected.to validate_absence_of(:name) }
    it { is_expected.to validate_absence_of(:email) }
    it { is_expected.to validate_absence_of(:password) }
  end

  context 'for a registered user' do
    subject { build(:user, password: nil) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
  end

  describe 'by_name scope' do
    it 'matches case-insensitively' do
      u = User.by_name(persisted_user.name).first
      expect(u).to eq(persisted_user)
    end
  end

  it 'reserves certain slugs case-insensitively' do
    user = User.new(slug: 'admin')
    expect(user).to be_invalid
    expect(user.errors[:slug]).not_to be_empty
  end

  it 'does not allow a swastika in a username' do
    user = User.new(name: '卐 Nazi Scum 卐')
    expect(user).to be_invalid
    expect(user.errors[:name]).not_to be_empty
  end

  it 'does not allow a newline in a username' do
    user = User.new(name: "Foo\nBar")
    expect(user).to be_invalid
    expect(user.errors[:name]).not_to be_empty
  end

  it 'does not allow control characters in a username' do
    user = User.new(name: "Foo\0Bar")
    expect(user).to be_invalid
    expect(user.errors[:name]).not_to be_empty
  end

  describe 'find_for_auth' do
    it 'is able to query by email' do
      u = User.find_for_auth(persisted_user.email)
      expect(u).to eq(persisted_user)
    end
  end

  describe '#pro?' do
    it 'returns false if the user has no pro expiry' do
      user = build(:user, pro_expires_at: nil, pro_tier: nil)
      expect(user).not_to be_pro
    end

    it 'returns false if the user has already run out of pro' do
      user = build(:user, pro_expires_at: 2.months.ago, pro_tier: 'pro')
      expect(user).not_to be_pro
    end

    it 'returns true if the user still has pro left' do
      user = build(:user, pro_expires_at: 2.months.from_now, pro_tier: 'pro')
      expect(user).to be_pro
    end

    it 'returns true if the user has ao_pro and no expiration' do
      user = build(:user, pro_tier: 'ao_pro', pro_expires_at: nil)
      expect(user).to be_pro
    end

    it 'returns true if the user has ao_pro and a past expiration' do
      user = build(:user, pro_tier: 'ao_pro', pro_expires_at: 6.months.ago)
      expect(user).to be_pro
    end
  end

  describe 'past_names' do
    subject { create(:user) }

    context 'when the user changes name for the first time' do
      it 'includes the old name' do
        old_name = subject.name
        subject.name = 'MisakaMikoto'
        subject.save!
        expect(subject.past_names).to include(old_name)
      end
    end

    it 'pushes onto the front when user changes name multiple times' do
      expect {
        3.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.by(3)
    end

    it 'limits to 10 in length' do
      expect {
        20.times do |i|
          subject.name = "Misaka100#{i}"
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(10)
    end

    it 'removes duplicate names' do
      expect {
        10.times do
          subject.name = 'MisakaMikoto'
          subject.save!
        end
      }.to change { subject.past_names.length }.from(0).to(1)
    end

    it 'returns first in list when previous_name is called' do
      3.times do |i|
        subject.name = "Misaka100#{i}"
        subject.save
      end
      expect(subject.past_names[0]).to equal(subject.previous_name)
    end
  end

  describe '#one_signal_player_ids' do
    it 'returns empty array when not subscribed to one signal' do
      expect(persisted_user.one_signal_player_ids).to be_empty
    end

    it 'returns array of user one signal player ids' do
      FactoryBot.create(:one_signal_player, user: persisted_user)
      FactoryBot.create(:one_signal_player,
        platform: :mobile,
        user: persisted_user)
      expect(persisted_user.one_signal_player_ids.length).to eq(2)
    end
  end

  describe '#profile_feed' do
    it 'returns a Feed::ProfileFeed instance' do
      expect(subject.profile_feed).to be_a(ProfileFeed)
    end
  end

  describe '#pro_streak' do
    context 'for a user with an active pro subscription' do
      it 'returns the length between the start of pro and now' do
        user = build(:user)
        Timecop.freeze do
          user.pro_started_at = 2.weeks.ago
          expect(user.pro_streak).to eq(2.weeks)
        end
      end
    end

    context 'for a user with a past pro subscription' do
      it 'returns the length between start and end of pro' do
        user = build(:user)
        Timecop.freeze do
          user.pro_started_at = 8.weeks.ago
          user.pro_expires_at = 1.week.ago
          expect(user.pro_streak).to eq(7.weeks)
        end
      end
    end
  end

  describe '#max_pro_streak' do
    it 'is updated in each User update' do
      user = create(:user, max_pro_streak: 2.weeks)
      Timecop.freeze do
        expect(user.max_pro_streak).to eq(2.weeks)
        user.update(pro_started_at: 4.weeks.ago)
        expect(user.max_pro_streak).to eq(4.weeks)
      end
    end
  end

  context 'after creation' do
    before do
      allow_any_instance_of(Feed).to receive(:follow)
      allow_any_instance_of(Feed).to receive(:unfollow)
    end

    it 'sets up the timeline' do
      timeline = double(:feed)
      allow(subject).to receive(:timeline).and_return(timeline)
      expect(timeline).to receive(:setup!)
      subject.save!
    end

    it 'sets up the profile feeds' do
      profile = double(:feed)
      allow(subject).to receive(:profile_feed).and_return(profile)
      expect(profile).to receive(:setup!)
      subject.save!
    end

    it 'sets up the site announcement feed' do
      announcements = double(:feed)
      allow(subject).to receive(:site_announcements_feed)
        .and_return(announcements)
      expect(announcements).to receive(:setup!)
      subject.save!
    end
  end

  context 'after email update' do
    it 'synchronizes the email to Stripe' do
      user = create(:user)
      expect(user.stripe_customer.email).to eq(user.email)
      user.update!(email: 'mariya@takeuchi.org')
      expect(user.stripe_customer.email).to eq('mariya@takeuchi.org')
    end
  end
end

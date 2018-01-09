# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  stats_data :jsonb            not null
#  type       :string           not null, indexed => [user_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed => [type], indexed
#
# Indexes
#
#  index_stats_on_type_and_user_id  (type,user_id) UNIQUE
#  index_stats_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_9e94901167  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Stat::AmountConsumed do
  # will create some library entries for me
  let(:user) { create(:user) }
  let(:anime) { create(:anime, :with_episodes, episode_count: 5) }
  let!(:stat) { Stat::AnimeAmountConsumed.for_user(user) }

  describe '#default_data' do
    it 'should have a media count' do
      expect(stat.default_data).to have_key('media')
      expect(stat.default_data['media']).to be_an(Integer)
    end

    it 'should have a count of units' do
      expect(stat.default_data).to have_key('units')
      expect(stat.default_data['units']).to be_an(Integer)
    end

    it 'should have a count of time' do
      expect(stat.default_data).to have_key('time')
      expect(stat.default_data['time']).to be_an(Integer)
    end
  end

  describe '#recalculate!' do
    before do
      # Set up the library
      anime_list = create_list(:anime, 3)
      anime_list.each { |a| create(:library_entry, user: user, anime: a, progress: 5) }
      stat.recalculate!
    end

    it 'should have the counts filled' do
      expect(stat.stats_data['media']).to eq(3)
      expect(stat.stats_data['units']).to eq(15)
      expect(stat.stats_data['time']).to be_a(Integer)
      expect(stat.stats_data['time']).not_to be_zero
    end
  end

  describe '#on_create' do
    let(:entry) { build(:library_entry, user: user, media: anime, progress: 3) }

    it 'should increase the media count' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['media'] }.by(1)
    end

    it 'should increase the units count' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['units'] }.by(entry.progress)
    end

    it 'should increase the time' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['time'] }.by_at_least(1)
    end
  end

  describe '#on_destroy' do
    let(:entry) { create(:library_entry, user: user, anime: anime, progress: 3) }

    it 'should decrease the media count' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['media'] }.by(-1)
    end

    it 'should decrease the units count' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['units'] }.by(-entry.progress)
    end

    it 'should decrease the time' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['time'] }.by_at_most(-1)
    end
  end
end

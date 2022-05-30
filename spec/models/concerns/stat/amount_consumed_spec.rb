require 'rails_helper'

RSpec.describe Stat::AmountConsumed do
  # will create some library entries for me
  let(:user) { create(:user) }
  let(:anime) { create(:anime, :with_episodes, episode_count: 5) }
  let!(:stat) { Stat::AnimeAmountConsumed.for_user(user) }

  before do
    allow(Kernel).to receive(:rand).and_return(1)
  end

  describe '#default_data' do
    it 'has a media count' do
      expect(stat.default_data).to have_key('media')
      expect(stat.default_data['media']).to be_an(Integer)
    end

    it 'has a count of units' do
      expect(stat.default_data).to have_key('units')
      expect(stat.default_data['units']).to be_an(Integer)
    end

    it 'has a count of time' do
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

    it 'has the counts filled' do
      expect(stat.stats_data['media']).to eq(3)
      expect(stat.stats_data['units']).to eq(15)
      expect(stat.stats_data['time']).to be_a(Integer)
      expect(stat.stats_data['time']).not_to be_zero
    end
  end

  describe '#on_create' do
    let(:entry) { build(:library_entry, user: user, media: anime, progress: 3) }

    it 'increases the media count' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['media'] }.by(1)
    end

    it 'increases the units count' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['units'] }.by(entry.progress)
    end

    it 'increases the time' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['time'] }.by_at_least(1)
    end
  end

  describe '#on_destroy' do
    let(:entry) do
      create(:library_entry,
        user: user,
        anime: anime,
        progress: 3,
        reconsume_count: 0,
        time_spent: 600)
    end

    before do
      stat.stats_data = {
        media: 50,
        units: 600,
        time: 20_000
      }
    end

    it 'decreases the media count' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['media'] }.by(-1)
    end

    it 'decreases the units count' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['units'] }.by(-entry.progress)
    end

    it 'decreases the time' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['time'] }.by_at_most(-1)
    end
  end
end

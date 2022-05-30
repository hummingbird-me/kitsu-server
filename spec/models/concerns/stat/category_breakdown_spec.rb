require 'rails_helper'

RSpec.describe Stat::CategoryBreakdown do
  let(:user) { create(:user) }
  let(:anime) { create(:anime, :categories) }
  let(:entry) { build(:library_entry, user: user, media: anime, status: :completed) }
  let!(:stat) { Stat::AnimeCategoryBreakdown.for_user(user) }

  describe '#default_data' do
    it 'has a total key' do
      expect(stat.default_data).to have_key('total')
    end

    it 'has a categories key' do
      expect(stat.default_data).to have_key('categories')
    end
  end

  describe '#recalculate!' do
    before do
      # Set up the library
      anime_list = create_list(:anime, 3, :categories)
      anime_list.each { |a| create(:library_entry, user: user, anime: a, status: :completed) }
      stat.recalculate!
    end

    it 'returns a list of categories with counts' do
      expect(stat.stats_data).to have_key('categories')
      expect(stat.stats_data['categories'].values).to all(be_a(Integer))
    end

    it 'returns the count of all applicable entries' do
      expect(stat.stats_data['total']).to eq(3)
    end
  end

  describe '#on_create' do
    it 'increases the total' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['total'] }.by(1)
    end

    it 'increments each category for the media' do
      category_count = anime.categories.count
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['categories'].values.sum }.by(category_count)
    end
  end

  describe '#on_destroy' do
    it 'decreases the total' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['total'] }.by(-1)
    end

    it 'decrements each category for the media' do
      category_count = anime.categories.count
      anime.categories.each do |category|
        stat.stats_data['categories'][category.id.to_s] = 10
      end

      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['categories'].values.sum }.by(-category_count)
    end
  end

  describe '#enriched_stats_data' do
    it 'replaces the keys in the categories hash with their titles' do
      expect(stat.enriched_stats_data['categories'].keys).to all(be_a(String))
    end
  end
end

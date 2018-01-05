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

RSpec.describe Stat::CategoryBreakdown do
  let(:user) { create(:user) }
  let(:anime) { create(:anime, :categories) }
  let(:entry) { create(:library_entry, user: user, anime: anime, status: :completed) }
  let!(:stat) { Stat::AnimeCategoryBreakdown.for_user(user) }

  describe '#default_data' do
    it 'should have a total key' do
      expect(stat.default_data).to have_key('total')
    end

    it 'should have a categories key' do
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

    it 'should return a list of categories with counts' do
      expect(stat.stats_data).to have_key('categories')
      expect(stat.stats_data['categories'].keys).to all(be_a(Integer))
      expect(stat.stats_data['categories'].values).to all(be_a(Integer))
    end

    it 'should return the count of all applicable entries' do
      expect(stat.stats_data['total']).to eq(3)
    end
  end

  describe '#on_create' do
    it 'should increase the total' do
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['total'] }.by(1)
    end

    it 'should increment each category for the media' do
      category_count = anime.categories.count
      expect {
        stat.on_create(entry)
      }.to change { stat.stats_data['categories'].values.sum }.by(category_count)
    end
  end

  describe '#on_destroy' do
    it 'should decrease the total' do
      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['total'] }.by(-1)
    end

    it 'should decrement each category for the media' do
      category_count = anime.categories.count
      anime.categories.each do |category|
        stat.stats_data['categories'][category.id] = 10
      end

      expect {
        stat.on_destroy(entry)
      }.to change { stat.stats_data['categories'].values.sum }.by(-category_count)
    end
  end

  describe '#enriched_stats_data' do
    it 'should replace the keys in the categories hash with their titles' do
      expect(stat.enriched_stats_data['categories'].keys).to all(be_a(String))
    end
  end
end

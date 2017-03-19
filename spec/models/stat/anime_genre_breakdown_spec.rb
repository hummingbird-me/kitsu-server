require 'rails_helper'

RSpec.describe Stat::AnimeGenreBreakdown do
  let(:user) { create(:user) }
  subject { create(:stat, user: user).becomes(Stat::AnimeGenreBreakdown) }

  let(:anime) { create(:anime, :genres) }
  let!(:le) { create(:library_entry, user: user, anime: anime) }

  describe '#recalculate!' do
    it 'should create or update Stat' do
      subject.recalculate!
      p Stat.first
      expect(Stat.first.stats_data).to_not be_nil
    end
  end
end

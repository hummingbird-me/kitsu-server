require 'rails_helper'

RSpec.describe TheTvdbService do
  before do
    stub_request(:post, 'https://api.thetvdb.com/login')
      .to_return(body: { 'token': '123456789' }.to_json)

    # https://api.thetvdb.com/series/80979/episodes/query?airedSeason=1
    stub_request(:get, %r{https://api.thetvdb.com/series/(\d)+/episodes/query?airedSeason=1})
      .to_return(body: fixture('the_tvdb_service/default_season1.json'))

    # https://api.thetvdb.com/series/80979/episodes
    stub_request(:get, %r{https://api.thetvdb.com/series/(\d)+/episodes})
      .to_return(body: fixture('the_tvdb_service/season_id.json'))
  end

  subject { described_class.new }
  let!(:anime) { create(:anime) }
  let!(:anime1) { create(:anime) }
  # let!(:episode) { create(:episode, media: anime, airdate: nil, synopsis: nil, length: nil) }
  # let!(:episode1) { create(:episode, media: anime1, airdate: nil, synopsis: nil, length: nil) }

  let!(:mapping1) { create(:mapping, external_site: 'thetvdb/series', external_id: '259653', media: anime) }
  let!(:mapping2) { create(:mapping, external_site: 'thetvdb/series', external_id: '80979', media: anime1) }
  let!(:mapping3) { create(:mapping, external_site: 'thetvdb/season', external_id: '29754', media: anime1) }

  describe '#weekly_import!' do
    it 'should only update nil values' do
      subject.weekly_import!
      # Need to check that only certain values get updated?
      # will need to precreate an episode and check the values after an update.
    end
  end
end

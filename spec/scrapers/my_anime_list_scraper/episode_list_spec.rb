require 'rails_helper'

RSpec.describe MyAnimeListScraper::EpisodeList do
  before do
    stub_request(:get, %r{https://myanimelist.net/anime/.*/episode})
      .to_return(fixture('scrapers/my_anime_list_scraper/anime_episodes_list.html'))
  end
  subject { described_class.new('https://myanimelist.net/anime/269/Bleach/episode') }

  describe '#call' do
    it 'should queue all the episodes for scraping' do
      allow(subject).to receive(:scrape_async)
      expect(subject).to receive(:scrape_async)
        .with(%r{https://myanimelist.net/anime/269/Bleach/episode/\d+})
        .exactly(100).times
      subject.call
    end

    it 'should queue the next page for scraping' do
      allow(subject).to receive(:scrape_async)
      expect(subject).to receive(:scrape_async)
        .with('https://myanimelist.net/anime/269/Bleach/episode?offset=100')
      subject.call
    end
  end
end

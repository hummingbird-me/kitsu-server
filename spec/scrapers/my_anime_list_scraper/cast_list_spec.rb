require 'rails_helper'

RSpec.describe MyAnimeListScraper::CastList do
  context 'for the cast of Your Name' do
    before do
      stub_request(:get, %r{https://myanimelist.net/anime/.*/characters})
        .to_return(fixture('scrapers/my_anime_list_scraper/anime_cast_list.html'))
    end
    subject { described_class.new('https://myanimelist.net/anime/32281/Kimi_no_Na_wa/characters') }

    describe '#call' do
      it 'should queue all the characters for scraping' do
        allow(subject).to receive(:scrape_async)
        expect(subject).to receive(:scrape_async)
          .with(%r{https://myanimelist.net/character/.*})
          .exactly(15).times
        subject.call
      end

      it 'should queue all the people for scraping' do
        allow(subject).to receive(:scrape_async)
        expect(subject).to receive(:scrape_async)
          .with(%r{https://myanimelist.net/people/.*})
          .exactly(122).times
        subject.call
      end
    end
  end
end

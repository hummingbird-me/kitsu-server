require 'rails_helper'

RSpec.describe MyAnimeListScraper::EpisodePage do
  context 'for an episode of a poorly-written shounen anime' do
    before do
      stub_request(:get, %r{https://myanimelist.net/anime/.*/episode/1})
        .to_return(fixture('scrapers/my_anime_list_scraper/anime_episode_page.html'))
    end
    subject { described_class.new('https://myanimelist.net/anime/269/Bleach/episode/1') }

    describe '#english_title' do
      it 'should return "The Day I Became a Shinigami"' do
        expect(subject.english_title).to eq('The Day I Became a Shinigami')
      end
    end

    describe '#japanese_title' do
      it 'should return "死神になっちゃった日"' do
        expect(subject.japanese_title).to eq('死神になっちゃった日')
      end
    end

    describe '#romaji_title' do
      it 'should return "Shinigami ni Natchatta Hi"' do
        expect(subject.romaji_title).to eq('Shinigami ni Natchatta Hi')
      end
    end

    describe '#synopsis' do
      it 'should return the entire synopsis text, cleaned' do
        expect(subject.synopsis).to start_with('A desert scene appears and ')
        expect(subject.synopsis).to end_with('ends up defeating said Hollow.')
      end
    end

    describe '#length' do
      it 'should return 24 minutes' do
        expect(subject.length).to eq(24.minutes)
      end
    end

    describe '#airdate' do
      it 'should return October 5, 2004' do
        expect(subject.airdate).to eq(Date.new(2004, 10, 5))
      end
    end

    describe '#filler?' do
      it 'should return false' do
        expect(subject.filler?).to be_falsey
      end
    end

    describe '#number' do
      it 'should return 1' do
        expect(subject.number).to eq(1)
      end
    end
  end
end

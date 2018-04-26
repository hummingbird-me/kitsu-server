require 'rails_helper'

RSpec.describe MyAnimeListScraper::AnimePage do
  context 'for a movie' do
    before do
      stub_request(:get, %r{https://myanimelist.net/anime/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/anime_detail_movie.html'))
    end
    subject { described_class.new('https://myanimelist.net/anime/306/Your_Name') }

    describe '#titles' do
      it 'should return a hash with string keys' do
        expect(subject.titles).to be_a(Hash)
        expect(subject.titles.keys).to all(be_a(String))
      end

      it 'should return the romaji title as en_jp' do
        expect(subject.titles['en_jp']).to eq('Kimi no Na wa.')
      end

      it 'should return the english title as en_us' do
        expect(subject.titles['en_us']).to eq('Your Name.')
      end

      it 'should return the original kanji title as ja_jp' do
        expect(subject.titles['ja_jp']).to eq('君の名は。')
      end
    end

    describe '#age_rating' do
      it 'should return :PG' do
        expect(subject.age_rating).to eq(:PG)
      end
    end

    describe '#age_rating_guide' do
      it 'should return "Teens 13 or older"' do
        expect(subject.age_rating_guide).to eq('Teens 13 or older')
      end
    end

    describe '#productions' do
      it 'should return a list of AnimeProduction objects' do
        expect(subject.productions).to all(be_a(AnimeProduction))
      end

      it 'should include "Toho" as a producer' do
        toho_production = subject.productions.find { |prod| prod.producer.name == 'Toho' }
        expect(toho_production).to be_present
        expect(toho_production.role).to eq('producer')
      end

      it 'should include "Funimation" as a licensor' do
        funi_production = subject.productions.find { |prod| prod.producer.name == 'Funimation' }
        expect(funi_production).to be_present
        expect(funi_production.role).to eq('licensor')
      end

      it 'should include "CoMix Wave Films" as a studio' do
        comix_wave_production = subject.productions.find do |prod|
          prod.producer.name == 'CoMix Wave Films'
        end
        expect(comix_wave_production).to be_present
        expect(comix_wave_production.role).to eq('studio')
      end
    end

    describe '#episode_length' do
      it 'should return 106 (minutes)' do
        expect(subject.episode_length).to eq(106)
      end
    end

    describe '#import' do
      it 'should return a changed Anime instance' do
        expect(subject.import).to be_changed
      end
    end

    describe '#call' do
      it 'should not queue a scraper for the episode list' do
        allow(subject).to receive(:scrape_async)
        expect(subject).not_to receive(:scrape_async)
          .with('https://myanimelist.net/anime/306/Your_Name/episode')
        subject.call
      end

      it 'should queue a scraper for the characters list' do
        allow(subject).to receive(:scrape_async)
        expect(subject).to receive(:scrape_async)
          .with('https://myanimelist.net/anime/306/Your_Name/characters').once
        subject.call
      end
    end
  end

  context 'for a TV Series' do
    before do
      stub_request(:get, %r{https://myanimelist.net/anime/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/anime_detail_tv.html'))
    end
    subject { described_class.new('https://myanimelist.net/anime/306/Abenobashi') }

    describe '#call' do
      it 'should queue a scraper for the episode list' do
        allow(subject).to receive(:scrape_async)
        expect(subject).not_to receive(:scrape_async)
          .with('https://myanimelist.net/anime/306/Your_Name/episode')
        subject.call
      end
    end
  end
end

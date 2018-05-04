require 'rails_helper'

RSpec.describe MyAnimeListScraper::CharacterPage do
  context 'for Akari Shinohara' do
    before do
      stub_request(:get, %r{https://myanimelist.net/character/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/character_basic.html'))
    end
    subject { described_class.new('https://myanimelist.net/character/1811/Akari_Shinohara') }

    describe '#japanese_name' do
      it 'should return "篠原 明里"' do
        expect(subject.japanese_name).to eq('篠原 明里')
      end
    end

    describe '#english_name' do
      it 'should return "Akari Shinohara"' do
        expect(subject.english_name).to eq('Akari Shinohara')
      end
    end

    describe '#synopsis' do
      it 'should replace spoiler tags with <spoiler>' do
        expect(subject.synopsis).to match(/<spoiler>Later on, due/)
      end
    end

    describe '#image' do
      it 'should return a URI' do
        expect(subject.image).to be_a(URI)
      end

      it 'should return the large image' do
        expect(subject.image.to_s).to include('l.')
      end
    end
  end
end

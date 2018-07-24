require 'rails_helper'

RSpec.describe MyAnimeListScraper::CharacterPage do
  include_context 'MAL CDN'
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

    describe '#description' do
      it 'should replace spoiler tags with <spoiler>' do
        expect(subject.description).to match(/<spoiler>Later on, due/)
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

    describe '#media_characters' do
      let(:anime) { create(:anime) }
      let!(:anime_mapping) do
        Mapping.create!(item: anime, external_site: 'myanimelist/anime', external_id: '1689')
      end
      let(:manga) { create(:manga) }
      let!(:manga_mapping) do
        Mapping.create!(item: manga, external_site: 'myanimelist/manga', external_id: '23419')
      end

      it 'should return a list of MediaCharacter instances' do
        expect(subject.media_characters).to all(be_an(MediaCharacter))
      end

      it 'should include the mapped anime' do
        media = subject.media_characters.map(&:media)
        expect(media).to include(anime)
      end

      it 'should include the mapped manga' do
        media = subject.media_characters.map(&:media)
        expect(media).to include(manga)
      end
    end
  end
end

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

    describe '#anime_characters' do
      let(:anime) { create(:anime) }
      let!(:mapping) do
        Mapping.create!(item: anime, external_site: 'myanimelist/anime', external_id: '1689')
      end

      it 'should return a list of AnimeCharacter instances' do
        expect(subject.anime_characters).to all(be_an(AnimeCharacter))
      end

      it 'should include the mapped anime' do
        anime_ids = subject.anime_characters.map(&:anime_id)
        expect(anime_ids).to include(anime.id)
      end
    end

    describe '#manga_characters' do
      let(:manga) { create(:manga) }
      let!(:mapping) do
        Mapping.create!(item: manga, external_site: 'myanimelist/manga', external_id: '23419')
      end

      it 'should return a list of MangaCharacter instances' do
        expect(subject.manga_characters).to all(be_an(MangaCharacter))
      end

      it 'should include the mapped manga' do
        manga_ids = subject.manga_characters.map(&:manga_id)
        expect(manga_ids).to include(manga.id)
      end
    end
  end
end

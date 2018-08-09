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
        subject.extend(ScraperMock)
        subject.call
        expect(subject.scraped_urls).to include(match(%r{https://myanimelist.net/character/.*}))
      end

      it 'should queue all the people for scraping' do
        subject.extend(ScraperMock)
        subject.call
        expect(subject.scraped_urls).to include(match(%r{https://myanimelist.net/people/.*}))
      end
    end

    describe '#characters' do
      let(:media) { create(:anime) }
      before do
        Mapping.create!(item: media, external_site: 'myanimelist/anime', external_id: '32281')
        [137_467, 136_805].each do |mal_id|
          character = create(:character)
          Mapping.create!(
            item: character,
            external_site: 'myanimelist/character',
            external_id: mal_id
          )
        end
      end

      it 'should return a list of MediaCharacter objects for characters already in our DB' do
        characters = subject.characters
        expect(characters.count).to eq(2)
        expect(characters).to all(be_a(MediaCharacter))
      end
    end

    describe '#staff' do
      let(:media) { create(:anime) }
      let(:person) { create(:person) }
      before do
        Mapping.create!(item: media, external_site: 'myanimelist/anime', external_id: '32281')
        Mapping.create!(item: person, external_site: 'myanimelist/people', external_id: '32577')
      end

      it 'should return a list of MediaStaff objects for people already in our DB' do
        staff = subject.staff
        people = staff.map(&:person)
        expect(people).to include(person)
        expect(staff).to all(be_a(MediaStaff))
      end
    end
  end

  context 'for the character list of Monster' do
    before do
      stub_request(:get, %r{https://myanimelist.net/manga/.*/characters})
        .to_return(fixture('scrapers/my_anime_list_scraper/manga_characters.html'))
    end
    subject { described_class.new('https://myanimelist.net/manga/1/Monster/characters') }

    describe '#staff' do
      it 'should return an empty array' do
        expect(subject.staff).to be_empty
      end
    end

    describe '#characters' do
      let(:media) { create(:manga) }
      before do
        Mapping.create!(item: media, external_site: 'myanimelist/manga', external_id: '1')
        [720, 719, 718, 8612].each do |mal_id|
          character = create(:character)
          Mapping.create!(
            item: character,
            external_site: 'myanimelist/character',
            external_id: mal_id
          )
        end
      end

      it 'should return a list of MediaCharacter objects for characters already in our DB' do
        characters = subject.characters
        expect(characters.count).to eq(4)
        expect(characters).to all(be_a(MediaCharacter))
      end
    end
  end
end

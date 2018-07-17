require 'rails_helper'

RSpec.describe MyAnimeListScraper::MangaPage do
  context 'for an ongoing manga' do
    before do
      stub_request(:get, %r{https://myanimelist.net/manga/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/manga_detail_ongoing.html'))
    end
    subject { described_class.new('https://myanimelist.net/manga/13/One_Piece') }

    describe '#chapter_count' do
      it 'should return nil' do
        expect(subject.chapter_count).to be_nil
      end
    end

    describe '#volume_count' do
      it 'should return nil' do
        expect(subject.volume_count).to be_nil
      end
    end

    describe '#import' do
      it 'should return a changed Manga instance' do
        expect(subject.import).to be_changed
      end
    end

    describe '#call' do
      it 'should queue a scraper for the characters list' do
        allow(subject).to receive(:scrape_async)
        expect(subject).to receive(:scrape_async)
          .with('https://myanimelist.net/manga/13/One_Piece/characters').once
        subject.call
      end
    end
  end

  context 'for a manga with multiple authors and no synopsis/background' do
    before do
      stub_request(:get, %r{https://myanimelist.net/manga/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/manga_detail_empty.html'))
    end
    subject { described_class.new('https://myanimelist.net/manga/109855/Mamono_Friends') }
    let(:artist) { create(:person, name: 'Z-ton') }
    let!(:artist_mapping) do
      Mapping.create!(
        item: artist,
        external_site: 'myanimelist/person',
        external_id: '23071'
      )
    end
    let(:writer) { create(:person, name: 'Tetsu Habara') }
    let!(:writer_mapping) do
      Mapping.create!(
        item: writer,
        external_site: 'myanimelist/person',
        external_id: '27379'
      )
    end

    describe '#staff' do
      it 'should include each person and their role' do
        expect(subject.staff.count).to eq(2)
        staff = subject.staff.map { |s| [s.person.name, s.role] }
        expect(staff).to include(['Z-ton', 'Art'])
        expect(staff).to include(['Tetsu Habara', 'Story'])
      end

      it 'should return a list of MangaStaff objects' do
        expect(subject.staff).to all(be_a(MangaStaff))
      end
    end
  end
end

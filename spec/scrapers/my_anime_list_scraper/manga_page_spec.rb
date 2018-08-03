require 'rails_helper'

RSpec.describe MyAnimeListScraper::MangaPage do
  include_context 'MAL CDN'
  context 'for an ongoing manga' do
    before do
      stub_request(:get, %r{https://myanimelist.net/manga/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/manga_detail_ongoing.html'))
    end
    subject { described_class.new('https://myanimelist.net/manga/13/One_Piece') }

    describe '#start_date' do
      it 'should return the correct day' do
        expect(subject.start_date).to eq(Date.new(1997, 7, 22))
      end
    end

    describe '#end_date' do
      it 'should return nil' do
        expect(subject.end_date).to be_nil
      end
    end

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
        external_site: 'myanimelist/people',
        external_id: '23071'
      )
    end
    let(:writer) { create(:person, name: 'Tetsu Habara') }
    let!(:writer_mapping) do
      Mapping.create!(
        item: writer,
        external_site: 'myanimelist/people',
        external_id: '27379'
      )
    end
    let(:media) { create(:manga) }
    let!(:media_mapping) do
      Mapping.create!(
        item: media,
        external_site: 'myanimelist/manga',
        external_id: '109855'
      )
    end

    describe '#start_date' do
      it 'should be the same as the end_date' do
        expect(subject.start_date).to eq(subject.end_date)
      end

      it 'should be October 18th, 2017' do
        expect(subject.start_date).to eq(Date.new(2017, 10, 18))
      end
    end

    describe '#staff' do
      it 'should include each person and their role' do
        expect(subject.staff.count).to eq(2)
        staff = subject.staff.map { |s| [s.person.name, s.role] }
        expect(staff).to include(['Z-ton', 'Art'])
        expect(staff).to include(['Tetsu Habara', 'Story'])
      end

      it 'should return a list of MediaStaff objects' do
        expect(subject.staff).to all(be_a(MediaStaff))
      end

      it 'should not recreate MediaStaff rows when they already exist' do
        existing_staff = MediaStaff.create!(media: media, person: artist, role: 'Art')
        expect(subject.staff).to include(existing_staff)
      end
    end

    describe '#volume_count' do
      it 'should return 1' do
        expect(subject.volume_count).to eq(1)
      end
    end
  end
end

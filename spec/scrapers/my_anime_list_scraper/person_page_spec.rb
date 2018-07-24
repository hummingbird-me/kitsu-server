require 'rails_helper'

RSpec.describe MyAnimeListScraper::PersonPage do
  include_context 'MAL CDN'
  context 'for voice actress Tara Platt' do
    before do
      stub_request(:get, %r{https://myanimelist.net/people/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/voice_actor.html'))
    end
    subject { described_class.new('https://myanimelist.net/people/244/Tara_Platt') }

    describe '#japanese_name' do
      it 'should return nil' do
        expect(subject.japanese_name).to be_nil
      end
    end

    describe '#english_name' do
      it 'should return "Tara Platt"' do
        expect(subject.english_name).to eq('Tara Platt')
      end
    end

    describe '#description' do
      it 'should include the part about her husband' do
        expect(subject.description).to match(/Yuri Lowenthal/)
      end
    end

    describe '#birthday' do
      it 'should be June 18, 1978' do
        expect(subject.birthday).to eq(Date.new(1978, 6, 18))
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

    describe '#staff' do
      it 'should return an empty array' do
        expect(subject.staff).to eq([])
      end
    end
  end

  context 'for esteemed director Makoto Shinkai' do
    before do
      stub_request(:get, %r{https://myanimelist.net/people/.*})
        .to_return(fixture('scrapers/my_anime_list_scraper/director.html'))
    end
    subject { described_class.new('https://myanimelist.net/people/1117/Makoto_Shinkai') }

    describe '#japanese_name' do
      it 'should return "新海 誠"' do
        expect(subject.japanese_name).to eq('新海 誠')
      end
    end

    describe '#english_name' do
      it 'should return "Makoto Shinkai"' do
        expect(subject.english_name).to eq('Makoto Shinkai')
      end
    end

    describe '#staff' do
      let(:anime) { create(:anime) }
      before do
        anime.mappings.create(external_site: 'myanimelist/anime', external_id: '1689')
      end

      it 'should return a list of MediaStaff' do
        expect(subject.staff).to all(be_a(MediaStaff))
      end

      it 'should return staff rows only for media already in our DB' do
        media = subject.staff.map(&:media)
        expect(media).to include(anime)
      end

      it 'should merge multiple rows of the same series into a single MediaStaff' do
        cms = subject.staff.select { |staff| staff.media == anime }
        expect(cms.count).to eq(1)
        expect(cms.first.role).to include('Editing')
        expect(cms.first.role).to include('Director')
        expect(cms.first.role).to include('Storyboard')
        expect(cms.first.role).to include('Script')
      end
    end
  end
end

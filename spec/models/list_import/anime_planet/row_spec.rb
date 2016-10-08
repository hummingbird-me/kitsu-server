require 'rails_helper'

RSpec.describe ListImport::AnimePlanet::Row do
  let(:anime) { fixture('list_import/anime_planet/toy-anime.html') }
  let(:manga) { fixture('list_import/anime_planet/toy-manga.html') }



  context 'Anime' do
    subject { described_class.new(
      Nokogiri::HTML(anime).css('table.personalList tr')[1]
    )}
    describe '#media_info' do
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('07-Ghost')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq('TV')
      end

      it 'should return episodes watched' do
        expect(subject.media_info[:episode_count]).to eq(25)
      end
    end

    describe '#status' do
      context 'of "Watched"' do
        it 'should return :completed' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[1])

          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "Watching"' do
        it 'should return :current' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[2])

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "Want to Watch"' do
        it 'should return :planned' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[3])

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "Stalled"' do
        it 'should return :on_hold' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[4])

          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "Dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[5])

          expect(subject.status).to eq(:dropped)
        end
      end
      context 'of "Wont Watch"' do
        it 'should return :what_the_fuck_goes_here' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[6])

          pending "What the fuck is this actually?"
          # expect(subject.status).to eq(:what_the_fuck_goes_here_seriously)
        end
      end
    end
  end

  context 'Manga' do
    subject { described_class.new(
      Nokogiri::HTML(manga).css('table.personalList tr')[1]
    )}
    describe '#media_info' do
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('07-Ghost')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq(nil)
      end

      it 'should return episodes watched' do
        expect(subject.media_info[:episode_count]).to eq(nil)
      end
    end
  end
end

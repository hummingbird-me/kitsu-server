require 'rails_helper'

RSpec.describe ListImport::AnimePlanet::Row do
  let(:anime) { fixture('list_import/anime_planet/toy-anime.html') }
  let(:manga) { fixture('list_import/anime_planet/toy-manga.html') }



  context 'Anime' do
    subject { described_class.new(
      Nokogiri::HTML(anime).css('table.personalList tr')[1],
      'anime'
    )}
    describe '#media' do
      # will figure out how to test.
    end

    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(2353)
      end
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('07-Ghost')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq('TV')
      end

      context 'total episodes' do
        it 'should return an integer' do
          expect(subject.media_info[:episode_count]).to eq(25)
        end

        it 'should return 0 if no episodes present' do
          pending "No example found yet"
        end
      end

      it 'should not return total amount of chapters' do
        expect(subject.media_info[:chapter_count]).to eq(nil)
      end
    end

    describe '#status' do
      context 'of "Watched"' do
        it 'should return :completed' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[1], 'anime')

          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "Watching"' do
        it 'should return :current' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[2], 'anime')

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "Want to Watch"' do
        it 'should return :planned' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[3], 'anime')

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "Stalled"' do
        it 'should return :on_hold' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[4], 'anime')

          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "Dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[5], 'anime')

          expect(subject.status).to eq(:dropped)
        end
      end
      context 'of "Wont Watch"' do
        it 'should be ignored' do
          subject = described_class.new(Nokogiri::HTML(anime).css('table.personalList tr')[6], 'anime')

          expect(subject.status).to eq(nil)
        end
      end
    end

    describe '#progress' do
      it 'should return the number of episodes watched' do
        expect(subject.progress).to eq(25)
      end
    end

    describe '#volumes' do
      it 'should not exist' do
        expect(subject.volumes).to eq(nil)
      end
    end

    describe '#rating' do
      it 'should return number as a float' do
        expect(subject.rating).to eq(5.0)
      end
    end

    describe '#reconsume_count' do
      it 'shoult return amount of times watched' do
        expect(subject.reconsume_count).to eq(1)
      end
    end
  end




  context 'Manga' do
    subject { described_class.new(
      Nokogiri::HTML(manga).css('table.personalList tr')[1],
      'manga'
    )}
    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(1854)
      end
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('1/2 Prince')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq(nil)
      end

      it 'should not return total amount of episodes' do
        expect(subject.media_info[:episode_count]).to eq(nil)
      end

      context 'total chapters' do
        it 'should return an integer' do
          expect(subject.media_info[:chapter_count]).to eq(76)
        end

        it 'should return 0 if no chapters present' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr').last, 'manga')

          expect(subject.media_info[:chapter_count]).to eq(0)
        end
      end
    end

    describe '#status' do
      context 'of "Read"' do
        it 'should return :completed' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[4], 'manga')

          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "Reading"' do
        it 'should return :current' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[1], 'manga')

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "Want to Read"' do
        it 'should return :planned' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[2], 'manga')

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "Stalled"' do
        it 'should return :on_hold' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[3], 'manga')

          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "Dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[5], 'manga')

          expect(subject.status).to eq(:dropped)
        end
      end
      context 'of "Wont Read"' do
        it 'should be ignored' do
          subject = described_class.new(Nokogiri::HTML(manga).css('table.personalList tr')[6], 'manga')

          expect(subject.status).to eq(nil)
        end
      end
    end

    describe '#progress' do
      it 'should return the number of chapters read' do
        expect(subject.progress).to eq(0)
      end
    end

    describe '#volumes' do
      it 'should return number of volumes read' do
        expect(subject.volumes).to eq(11)
      end
    end

    describe '#rating' do
      it 'should return number as a float' do
        expect(subject.rating).to eq(2.5)
      end
    end

    describe '#reconsume_count' do
      it 'shoult not exist' do
        expect(subject.reconsume_count).to eq(nil)
      end
    end
  end




end

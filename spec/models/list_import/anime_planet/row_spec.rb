require 'rails_helper'

RSpec.describe ListImport::AnimePlanet::Row do
  let(:anime) { fixture('list_import/anime_planet/toy-anime.html') }
  let(:manga) { fixture('list_import/anime_planet/toy-manga.html') }

  context 'Anime' do
    subject do
      described_class.new(
        Nokogiri::HTML(anime).css('.cardDeck .card').first,
        'anime'
      )
    end

    describe '#media' do
      it 'should work for lookup' do
        expect(Mapping).to receive(:lookup).with('animeplanet', 'anime/2353')
          .and_return('hello')

        subject.media
      end

      it 'should work for guess_algolia' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess_algolia).with(Anime, '07-Ghost').and_return('hello')

        subject.media
      end
    end

    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(2353)
      end
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('07-Ghost')
      end

      it 'should return subtype' do
        expect(subject.media_info[:subtype]).to eq('TV')
      end

      it 'should return total episodes' do
        expect(subject.media_info[:episode_count]).to eq(25)
      end

      it 'should not return total amount of chapters' do
        expect(subject.media_info[:chapter_count]).to eq(nil)
      end
    end

    describe '#status' do
      context 'of "Watched"' do
        it 'should return :completed' do
          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "Watching"' do
        it 'should return :current' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[1],
            'anime'
          )

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "Want to Watch"' do
        it 'should return :planned' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[2],
            'anime'
          )

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "Stalled"' do
        it 'should return :on_hold' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[3],
            'anime'
          )

          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "Dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[4],
            'anime'
          )

          expect(subject.status).to eq(:dropped)
        end
      end
      context 'of "Wont Watch"' do
        it 'should be ignored' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[5],
            'anime'
          )

          expect(subject.status).to eq(nil)
        end
      end
    end

    describe '#progress' do
      context 'Watched' do
        it 'should return total episodes' do
          expect(subject.progress).to eq(25)
        end
      end
      context 'Watching' do
        it 'should return episodes watched' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[1],
            'anime'
          )
          expect(subject.progress).to eq(1)
        end
      end
      context 'Want to Watch' do
        it 'should always return 0 episodes' do
          subject = described_class.new(
            Nokogiri::HTML(anime).css('.cardDeck .card')[2],
            'anime'
          )
          expect(subject.progress).to eq(0)
        end
      end
    end

    describe '#volumes' do
      it 'should not exist' do
        expect(subject.volumes).to eq(nil)
      end
    end

    describe '#rating' do
      it 'should return number quadrupled to match our 20-point scale' do
        expect(subject.rating).to eq(20)
      end
    end

    describe '#reconsume_count' do
      it 'should return amount of times watched' do
        expect(subject.reconsume_count).to eq(1)
      end
    end
  end

  context 'Manga' do
    subject do
      described_class.new(
        Nokogiri::HTML(manga).css('.cardDeck .card').first,
        'manga'
      )
    end

    describe '#media' do
      it 'should work for lookup' do
        expect(Mapping).to receive(:lookup).with('animeplanet', 'manga/1854')
          .and_return('hello')

        subject.media
      end

      it 'should work for guess_algolia' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess_algolia).with(Manga, '1/2 Prince').and_return('hello')

        subject.media
      end
    end

    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(1854)
      end
      it 'should return the title' do
        expect(subject.media_info[:title]).to eq('1/2 Prince')
      end

      it 'should return subtype' do
        expect(subject.media_info[:subtype]).to eq(nil)
      end

      it 'should not return total amount of episodes' do
        expect(subject.media_info[:episode_count]).to eq(nil)
      end

      context 'total chapters' do
        it 'should return an integer' do
          expect(subject.media_info[:chapter_count]).to eq(76)
        end

        it 'should return 0 if no chapters present' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card').last,
            'manga'
          )

          expect(subject.media_info[:chapter_count]).to eq(0)
        end
      end
    end

    describe '#status' do
      context 'of "Read"' do
        it 'should return :completed' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[3],
            'manga'
          )

          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "Reading"' do
        it 'should return :current' do
          expect(subject.status).to eq(:current)
        end
      end
      context 'of "Want to Read"' do
        it 'should return :planned' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[1],
            'manga'
          )

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "Stalled"' do
        it 'should return :on_hold' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[2],
            'manga'
          )

          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "Dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[4],
            'manga'
          )

          expect(subject.status).to eq(:dropped)
        end
      end
      context 'of "Wont Read"' do
        it 'should be ignored' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[5],
            'manga'
          )

          expect(subject.status).to eq(nil)
        end
      end
    end

    describe '#progress' do
      context 'Stored as Volumes' do
        it 'should always return 0' do
          expect(subject.progress).to eq(0)
        end
      end
      context 'Stored as Chapters' do
        context 'Read' do
          it 'should return all chapters' do
            subject = described_class.new(
              Nokogiri::HTML(manga).css('.cardDeck .card')[3],
              'manga'
            )
            expect(subject.progress).to eq(357)
          end
        end

        context 'Reading' do
          it 'should return chapters read' do
            subject = described_class.new(
              Nokogiri::HTML(manga).css('.cardDeck .card')[2],
              'manga'
            )
            expect(subject.progress).to eq(13)
          end
        end
      end
    end

    describe '#volumes' do
      context 'Read' do
        it 'should return all volumes' do
          subject = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[3],
            'manga'
          )

          expect(subject.volumes).to eq(37)
        end
      end
      context 'Reading' do
        it 'should return number of volumes read' do
          expect(subject.volumes).to eq(11)
        end
      end
    end

    describe '#rating' do
      it 'should return number quadrupled' do
        expect(subject.rating).to eq(10)
      end
    end

    describe '#reconsume_count' do
      it 'should not exist' do
        expect(subject.reconsume_count).to eq(nil)
      end
    end
  end
end

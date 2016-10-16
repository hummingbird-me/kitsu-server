require 'rails_helper'

RSpec.describe ListImport::Anilist::Row do
  let(:anime) { fixture('list_import/anilist/toy-anime.json') }
  let(:manga) { fixture('list_import/anilist/toy-manga.json') }

  context 'Anime' do
    subject do
      described_class.new(
        JSON.parse(anime)['lists']['on_hold'].first,
        'anime'
      )
    end

    describe '#media' do
      it 'should work for lookup' do
        expect(Mapping).to receive(:lookup).with('anilist', 'anime/1')
          .and_return('hello')

        subject.media
      end

      it 'should work for guess' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess).with(Anime, {
          id: 1,
          title: 'COWBOY BEBOP',
          show_type: 'TV',
          episode_count: 26
        }).and_return('hello')

        subject.media
      end
    end

    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(1)
      end
      it 'should return the romaji title' do
        expect(subject.media_info[:title]).to eq('COWBOY BEBOP')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq('TV')
      end

      it 'should return total episodes' do
        expect(subject.media_info[:episode_count]).to eq(26)
      end

      it 'should not return total amount of chapters' do
        expect(subject.media_info[:chapter_count]).to eq(nil)
      end
    end

    describe '#status' do
      context 'of "completed"' do
        it 'should return :completed' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'].first,
            'anime'
          )

          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "watching"' do
        it 'should return :current' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['watching'].first,
            'anime'
          )

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "plan to watch"' do
        it 'should return :planned' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['plan_to_watch'].first,
            'anime'
          )

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "on-hold"' do
        it 'should return :on_hold' do
          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['dropped'].first,
            'anime'
          )

          expect(subject.status).to eq(:dropped)
        end
      end
    end

    describe '#progress' do
      it 'should return total episodes watched' do
        expect(subject.progress).to eq(1)
      end
    end

    describe '#volumes' do
      it 'should not exist' do
        expect(subject.volumes).to eq(nil)
      end
    end

    describe '#rating' do
      it 'should return nil if 0' do
        expect(subject.rating).to eq(nil)
      end

      it 'should return 3/100 as a float' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'][2],
          'anime'
        )

        expect(subject.rating).to eq(0.5)
      end

      it 'should return 90/20 as a float' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'].first,
          'anime'
        )

        expect(subject.rating).to eq(4.5)
      end

      it 'should return 69/20 as a float rounded to nearest 0.5' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'][1],
          'anime'
        )

        expect(subject.rating).to eq(3.5)
      end
    end

    describe '#reconsume_count' do
      context 'on-hold' do
        it 'should return amount of times rewatched' do
          expect(subject.reconsume_count).to eq(0)
        end
      end
      context 'completed' do
        it 'should return amount of times rewatched' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'].first,
            'anime'
          )

          expect(subject.reconsume_count).to eq(4)
        end
      end
    end
  end

  context 'Manga' do
    subject do
      described_class.new(
        JSON.parse(manga)['lists']['completed'].first,
        'manga'
      )
    end

    describe '#media' do
      it 'should work for lookup' do
        expect(Mapping).to receive(:lookup).with('anilist', 'manga/30933')
          .and_return('hello')

        subject.media
      end

      it 'should work for guess' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess).with(Manga, {
          id: 30_933,
          title: 'Elfen Lied',
          show_type: 'Manga',
          chapter_count: 113
        }).and_return('hello')

        subject.media
      end
    end

    describe '#media_info' do
      it 'should return the id' do
        expect(subject.media_info[:id]).to eq(30_933)
      end
      it 'should return the romaji title' do
        expect(subject.media_info[:title]).to eq('Elfen Lied')
      end

      it 'should return show_type' do
        expect(subject.media_info[:show_type]).to eq('Manga')
      end

      it 'should not return any episodes' do
        expect(subject.media_info[:episode_count]).to eq(nil)
      end

      it 'should return total amount of chapters' do
        expect(subject.media_info[:chapter_count]).to eq(113)
      end
    end

    describe '#status' do
      context 'of "completed"' do
        it 'should return :completed' do
          expect(subject.status).to eq(:completed)
        end
      end
      context 'of "reading"' do
        it 'should return :current' do
          subject = described_class.new(
            JSON.parse(manga)['lists']['reading'].first,
            'manga'
          )

          expect(subject.status).to eq(:current)
        end
      end
      context 'of "plan to read"' do
        it 'should return :planned' do
          subject = described_class.new(
            JSON.parse(manga)['lists']['plan_to_read'].first,
            'manga'
          )

          expect(subject.status).to eq(:planned)
        end
      end
      context 'of "on-hold"' do
        it 'should return :on_hold' do
          subject = described_class.new(
            JSON.parse(manga)['lists']['on_hold'].first,
            'manga'
          )
          expect(subject.status).to eq(:on_hold)
        end
      end
      context 'of "dropped"' do
        it 'should return :dropped' do
          subject = described_class.new(
            JSON.parse(manga)['lists']['dropped'].first,
            'manga'
          )

          expect(subject.status).to eq(:dropped)
        end
      end
    end

    describe '#progress' do
      it 'should return total chapters read' do
        expect(subject.progress).to eq(113)
      end
    end

    describe '#volumes' do
      it 'should return volumes read' do
        expect(subject.volumes).to eq(12)
      end
    end

    describe '#reconsume_count' do
      context 'on-hold' do
        it 'should return amount of times reread' do
          expect(subject.reconsume_count).to eq(0)
        end
      end

      context 'completed' do
        it 'should return amount of times reread' do
          subject = described_class.new(
            JSON.parse(manga)['lists']['completed'][1],
            'manga'
          )

          expect(subject.reconsume_count).to eq(69)
        end
      end
    end
  end
end

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

      it 'should work for guess_algolia' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess_algolia).with(Anime, 'COWBOY BEBOP').and_return('hello')

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

      it 'should return subtype' do
        expect(subject.media_info[:subtype]).to eq('TV')
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

      it 'should convert 3/100 to the minimum score' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'][2],
          'anime'
        )

        expect(subject.rating).to eq(2)
      end

      it 'should convert 90/100 to 18/20' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'].first,
          'anime'
        )

        expect(subject.rating).to eq(18)
      end

      it 'should convert 69/100 to 14/20' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'][1],
          'anime'
        )

        expect(subject.rating).to eq(14)
      end
    end

    describe '#reconsume_count' do
      it 'should return 0 if not rewatched' do
        expect(subject.reconsume_count).to eq(0)
      end
      it 'should return amount of times rewatched' do
        subject = described_class.new(
          JSON.parse(anime)['lists']['completed'].first,
          'anime'
        )

        expect(subject.reconsume_count).to eq(4)
      end
    end

    describe '#notes' do
      context 'with notes being empty' do
        it 'should return nil' do
          expect(subject.notes).to be_nil
        end
      end

      context 'with notes being filled out' do
        it 'should return text' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'].first,
            'anime'
          )

          expect(subject.notes).to_not be_nil
        end
      end
    end

    describe '#started_at' do
      context 'with date being empty' do
        it 'should return nil' do
          expect(subject.started_at).to be_nil
        end
      end
      context 'with YYYY existing' do
        it 'should default day and month to 01' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'][2],
            'anime'
          )
          # YYYY
          expect(subject.started_at).to eq(Date.new(2016))
        end
      end
      context 'with YYYY/MM existing' do
        it 'should default day to 01' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'][1],
            'anime'
          )
          # YYYY-MM
          expect(subject.started_at).to eq(Date.new(2016, 10))
        end
      end
      context 'with YYYY/MM/DD existing' do
        it 'should return a valid ISO 8601 date' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'].first,
            'anime'
          )
          # YYYY-MM-DD
          expect(subject.started_at).to eq(Date.new(2016, 10, 3))
        end
      end
    end

    describe '#finished_at' do
      context 'with date being empty' do
        it 'should return nil' do
          expect(subject.finished_at).to be_nil
        end
      end
      context 'with YYYY existing' do
        it 'should default day and month to 01' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'][2],
            'anime'
          )
          # YYYY
          expect(subject.finished_at).to eq(Date.new(2016))
        end
      end
      context 'with YYYY/MM existing' do
        it 'should default day to 01' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'][1],
            'anime'
          )
          # YYYY-MM
          expect(subject.finished_at).to eq(Date.new(2016, 10))
        end
      end
      context 'with YYYY/MM/DD existing' do
        it 'should return a valid ISO 8601 date' do
          subject = described_class.new(
            JSON.parse(anime)['lists']['completed'].first,
            'anime'
          )
          # YYYY-MM-DD
          expect(subject.finished_at).to eq(Date.new(2016, 10, 10))
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

      it 'should work for guess_algolia' do
        allow(Mapping).to receive(:lookup).and_return(nil)

        expect(Mapping).to receive(:guess_algolia).with(Manga, 'Elfen Lied').and_return('hello')

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

      it 'should return subtype' do
        expect(subject.media_info[:subtype]).to eq('Manga')
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
      it 'should return 0' do
        expect(subject.reconsume_count).to eq(0)
      end

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

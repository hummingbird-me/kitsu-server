require 'rails_helper'

RSpec.describe ListImport::AnimePlanet::Row do
  let(:anime) { fixture('list_import/anime_planet/toy-anime.html') }
  let(:manga) { fixture('list_import/anime_planet/toy-manga.html') }

  context 'for Anime' do
    subject(:row) do
      described_class.new(
        Nokogiri::HTML(anime).css('.cardDeck .card').first,
        'anime'
      )
    end

    describe '#media' do
      it 'works for lookup' do
        allow(Mapping).to receive(:lookup)
          .with('animeplanet', 'anime/2353')
          .and_return('hello')

        expect(row.media).to eq('hello')
      end

      it 'works for guess' do
        allow(Mapping).to receive(:lookup).and_return(nil)
        args = {
          id: 2353,
          title: '07-Ghost',
          subtype: 'TV',
          episode_count: 25
        }
        allow(Mapping).to receive(:guess).with(Anime, args).and_return('hello')

        expect(row.media).to eq('hello')
      end
    end

    describe '#media_info' do
      it 'returns the id' do
        expect(row.media_info[:id]).to eq(2353)
      end

      it 'returns the title' do
        expect(row.media_info[:title]).to eq('07-Ghost')
      end

      it 'returns subtype' do
        expect(row.media_info[:subtype]).to eq('TV')
      end

      it 'returns total episodes' do
        expect(row.media_info[:episode_count]).to eq(25)
      end

      it 'does not return total amount of chapters' do
        expect(row.media_info[:chapter_count]).to be_nil
      end
    end

    describe '#status' do
      it 'returns :completed for "Watched"' do
        expect(row.status).to eq(:completed)
      end

      it 'returns :current for "Watching"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[1],
          'anime'
        )

        expect(row.status).to eq(:current)
      end

      it 'returns :planned for "Want to Watch"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[2],
          'anime'
        )

        expect(row.status).to eq(:planned)
      end

      it 'returns :on_hold for "Stalled"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[3],
          'anime'
        )

        expect(row.status).to eq(:on_hold)
      end

      it 'returns :dropped for "Dropped"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[4],
          'anime'
        )

        expect(row.status).to eq(:dropped)
      end

      it 'is ignored for "Wont Watch"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[5],
          'anime'
        )

        expect(row.status).to be_nil
      end
    end

    describe '#progress' do
      it 'returns total episodes for "Watched"' do
        expect(row.progress).to eq(25)
      end

      it 'returns episodes watched for "Watching"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[1],
          'anime'
        )
        expect(row.progress).to eq(1)
      end

      it 'always returns 0 episodes for "Want to Watch"' do
        row = described_class.new(
          Nokogiri::HTML(anime).css('.cardDeck .card')[2],
          'anime'
        )
        expect(row.progress).to eq(0)
      end
    end

    describe '#volumes' do
      it 'does not exist' do
        expect(row.volumes).to be_nil
      end
    end

    describe '#rating' do
      it 'returns number quadrupled to match our 20-point scale' do
        expect(row.rating).to eq(20)
      end
    end

    describe '#reconsume_count' do
      it 'returns amount of times watched' do
        expect(row.reconsume_count).to eq(1)
      end
    end
  end

  context 'for Manga' do
    subject(:row) do
      described_class.new(
        Nokogiri::HTML(manga).css('.cardDeck .card').first,
        'manga'
      )
    end

    describe '#media' do
      it 'works for lookup' do
        allow(Mapping).to receive(:lookup)
          .with('animeplanet', 'manga/1854')
          .and_return('hello')

        expect(row.media).to eq('hello')
      end

      it 'works for guess' do
        allow(Mapping).to receive(:lookup).and_return(nil)
        args = {
          id: 1854,
          title: '1/2 Prince',
          chapter_count: 76
        }
        allow(Mapping).to receive(:guess).with(Manga, args).and_return('hello')

        expect(row.media).to eq('hello')
      end
    end

    describe '#media_info' do
      it 'returns the id' do
        expect(row.media_info[:id]).to eq(1854)
      end

      it 'returns the title' do
        expect(row.media_info[:title]).to eq('1/2 Prince')
      end

      it 'returns subtype' do
        expect(row.media_info[:subtype]).to be_nil
      end

      it 'does not return total amount of episodes' do
        expect(row.media_info[:episode_count]).to be_nil
      end

      describe '[:chapter_count]' do
        it 'returns an integer' do
          expect(row.media_info[:chapter_count]).to eq(76)
        end

        it 'returns 0 if no chapters present' do
          row = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card').last,
            'manga'
          )

          expect(row.media_info[:chapter_count]).to eq(0)
        end
      end
    end

    describe '#status' do
      it 'returns :completed for "Read"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[3],
          'manga'
        )

        expect(row.status).to eq(:completed)
      end

      it 'returns :current for "Reading"' do
        expect(row.status).to eq(:current)
      end

      it 'returns :planned for "Want to Read"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[1],
          'manga'
        )

        expect(row.status).to eq(:planned)
      end

      it 'returns :on_hold for "Stalled"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[2],
          'manga'
        )

        expect(row.status).to eq(:on_hold)
      end

      it 'returns :dropped for "Dropped"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[4],
          'manga'
        )

        expect(row.status).to eq(:dropped)
      end

      it 'is ignored for "Wont Read"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[5],
          'manga'
        )

        expect(row.status).to be_nil
      end
    end

    describe '#progress' do
      context 'when stored as volumes' do
        it 'always returns 0' do
          expect(row.progress).to eq(0)
        end
      end

      context 'when stored as chapters' do
        it 'returns all chapters when "Read"' do
          row = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[3],
            'manga'
          )
          expect(row.progress).to eq(357)
        end

        it 'returns chapters read when "Reading"' do
          row = described_class.new(
            Nokogiri::HTML(manga).css('.cardDeck .card')[2],
            'manga'
          )
          expect(row.progress).to eq(13)
        end
      end
    end

    describe '#volumes' do
      it 'returns all volumes when "Read"' do
        row = described_class.new(
          Nokogiri::HTML(manga).css('.cardDeck .card')[3],
          'manga'
        )

        expect(row.volumes).to eq(37)
      end

      it 'returns number of volumes read when "Reading"' do
        expect(row.volumes).to eq(11)
      end
    end

    describe '#rating' do
      it 'returns number quadrupled' do
        expect(row.rating).to eq(10)
      end
    end

    describe '#reconsume_count' do
      it 'does not exist' do
        expect(row.reconsume_count).to be_nil
      end
    end
  end
end

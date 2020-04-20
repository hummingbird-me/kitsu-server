require 'rails_helper'

RSpec.describe ListImport::AnilistV2::Row do
  shared_examples_for 'Anilist V2 generic row fields' do |klass|
    describe '#media_mapping' do
      it 'should work for anilist lookup' do
        expect(Mapping).to receive(:lookup)
          .with("AniList/#{type}", anilist_media_id)
          .and_return('hello')

        subject.media_mapping
      end

      it 'should work for myanimelist lookup' do
        allow(Mapping).to receive(:lookup).with("AniList/#{type}", anilist_media_id).and_return(nil)
        expect(Mapping).to receive(:lookup)
          .with("MyAnimeList #{type.capitalize}", mal_media_id)
          .and_return('hello')

        subject.media_mapping
      end

      it 'should work for guess' do
        allow(Mapping).to receive(:lookup).and_return(nil)
        expect(Mapping).to receive(:guess)
          .with(
            klass,
            guess_params
          ).and_return('hello')

        subject.media_mapping
      end
    end

    describe '#data' do
      it 'should create a hash with all fields removing any nil' do
        expect(subject.data).to include(formatted_data)
      end
    end

    describe '#score' do
      it 'should convert no score to nil' do
        media[:score] = 0

        expect(subject.data[:rating]).to be_nil
      end

      context 'properly converts from 100 point scale to 20 point scale for valid scores' do
        it 'generic conversion' do
          expect(subject.data[:rating]).to eq(rating)
        end

        it 'converts from 89 to 18' do
          media[:score] = 89

          expect(subject.data[:rating]).to eq(18)
        end
      end
    end

    describe '#status' do
      it 'is completed' do
        media['status'] = 'COMPLETED'

        expect(subject.data[:status]).to eq(:completed)
      end

      it 'is watching/reading' do
        media['status'] = 'CURRENT'

        expect(subject.data[:status]).to eq(:current)
      end

      it 'is planning' do
        media['status'] = 'PLANNING'

        expect(subject.data[:status]).to eq(:planned)
      end

      it 'is paused' do
        media['status'] = 'PAUSED'

        expect(subject.data[:status]).to eq(:on_hold)
      end

      it 'is dropped' do
        media['status'] = 'DROPPED'

        expect(subject.data[:status]).to eq(:dropped)
      end
    end

    describe '#reconsume_count' do
      it 'should exist' do
        expect(subject.data[:reconsume_count]).to eq(reconsume_count)
      end
    end

    describe '#progress' do
      it 'should exist' do
        expect(subject.data[:progress]).to eq(progress)
      end
    end

    describe '#notes' do
      it 'can optionally exist' do
        expect(subject.data[:notes]).to eq(notes)
      end
    end

    describe '#started_at' do
      it 'can optionally exist' do
        expect(subject.data[:started_at]).to eq(started_at)
      end

      it 'can be null' do
        media[:started_at] = { year: nil, month: nil, day: nil }

        expect(subject.data[:started_at]).to be_nil
      end
    end

    describe '#finished_at' do
      it 'can optionally exist' do
        expect(subject.data[:finished_at]).to eq(finished_at)
      end

      it 'can be null' do
        media[:completed_at] = { year: nil, month: nil, day: nil }

        expect(subject.data[:finished_at]).to be_nil
      end
    end
  end

  context 'Anime' do
    subject { described_class.new(JSON.parse(media.to_json, object_class: OpenStruct), type) }
    let(:media) { JSON.parse(fixture('list_import/anilist_v2/anime_completed_accel_world.json')).deep_transform_keys(&:underscore) }

    let(:formatted_data) do
      {
        rating: rating,
        status: :completed,
        reconsume_count: reconsume_count,
        progress: progress,
        started_at: started_at,
        finished_at: finished_at
      }
    end

    let(:type) { 'anime' }
    let(:rating) { 20 }
    let(:reconsume_count) { 3 }
    let(:progress) { 24 }
    let(:notes) { nil }
    let(:started_at) { '2012-09-03' }
    let(:finished_at) { '2012-09-21' }
    let(:anilist_media_id) { 11_759 }
    let(:mal_media_id) { 11_990 }
    let(:guess_params) do
      {
        title: 'Accel World',
        subtype: type,
        episode_count: 24
      }
    end

    it_behaves_like 'Anilist V2 generic row fields', Anime
  end

  context 'Manga' do
    subject { described_class.new(JSON.parse(media.to_json, object_class: OpenStruct), type) }
    let(:media) { JSON.parse(fixture('list_import/anilist_v2/manga_current_arifureta.json')).deep_transform_keys(&:underscore) }

    let(:formatted_data) do
      {
        rating: rating,
        notes: notes,
        status: :current,
        reconsume_count: reconsume_count,
        progress: progress,
        started_at: started_at
      }
    end

    let(:type) { 'manga' }
    let(:rating) { 14 }
    let(:reconsume_count) { 0 }
    let(:progress) { 38 }
    let(:notes) { 'The best notes!' }
    let(:started_at) { '2017-11-12' }
    let(:finished_at) { nil }
    let(:anilist_media_id) { 12_345 }
    let(:mal_media_id) { 96_528 }
    let(:guess_params) do
      {
        title: 'Arifureta Shokugyou de Sekai Saikyou',
        subtype: type
      }
    end

    it_behaves_like 'Anilist V2 generic row fields', Manga
  end
end

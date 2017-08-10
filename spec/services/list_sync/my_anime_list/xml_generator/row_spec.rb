require 'rails_helper'

RSpec.describe ListSync::MyAnimeList::XmlGenerator::Row do
  subject { described_class.new(library_entry) }
  let(:library_entry) { build(:library_entry, anime: media, media: media) }
  let(:mapping) { OpenStruct.new(external_id: '123') }
  let(:media) { build(:anime) }
  before { allow(media).to receive(:mapping_for).and_return(mapping) }

  describe '#to_xml' do
    subject { Nokogiri::XML(described_class.new(library_entry).to_xml) }
    context 'for an Anime' do
      let(:media) { build(:anime) }
      let(:library_entry) { build(:library_entry, anime: media, media: media) }

      it 'should have a series_animedb_id node' do
        expect(subject.at_css('series_animedb_id').content).to eq('123')
      end

      it 'should have a my_watched_episodes node' do
        expect(subject.at_css('my_watched_episodes')).not_to be_nil
      end

      it 'should have a my_times_watched node' do
        expect(subject.at_css('my_times_watched')).not_to be_nil
      end

      context 'on planned list' do
        before { library_entry.status = :planned }
        it 'should have a my_status node with "Plan to Watch"' do
          expect(subject.at_css('my_status').content).to eq('Plan to Watch')
        end
      end

      context 'on current list' do
        before { library_entry.status = :current }
        it 'should have a my_status node with "Watching"' do
          expect(subject.at_css('my_status').content).to eq('Watching')
        end
      end
    end

    context 'for a Manga' do
      let(:media) { build(:manga) }
      let(:library_entry) { build(:library_entry, manga: media, media: media) }

      it 'should have a manga_mangadb_id node' do
        expect(subject.at_css('manga_mangadb_id').content).to eq('123')
      end

      it 'should have a my_read_chapters node' do
        expect(subject.at_css('my_read_chapters')).not_to be_nil
      end

      it 'should have a my_read_volumes node' do
        expect(subject.at_css('my_read_volumes')).not_to be_nil
      end

      it 'should have a my_times_read node' do
        expect(subject.at_css('my_times_read')).not_to be_nil
      end
    end

    context 'with a started_at time' do
      before { library_entry.started_at = 1.week.ago }

      it 'should have a my_start_date node in YYYY-MM-DD format' do
        expect(subject.at_css('my_start_date')).to match(/\d{4}-\d{2}-\d{2}/)
      end
    end

    context 'with a finished_at time' do
      before { library_entry.finished_at = 1.week.ago }

      it 'should have a my_finish_date node in YYYY-MM-DD format' do
        expect(subject.at_css('my_finish_date')).to match(/\d{4}-\d{2}-\d{2}/)
      end
    end

    context 'with a rating' do
      let(:rating) { rand(2..20) }
      before { library_entry.rating = rating }

      it 'should have a my_score node with half the Kitsu rating' do
        expect(subject.at_css('my_score').content).to eq((rating / 2).to_s)
      end
    end

    context 'with comments and notes' do
      before { library_entry.notes = "Some comments\n=== MAL Tags ===\ntag1, tag2, tag3" }

      it 'should have comments and tags parsed from notes' do
        expect(subject.at_css('my_comments').content).to eq('Some comments')
        expect(subject.at_css('my_tags').content).to eq('tag1, tag2, tag3')
      end
    end
  end
end

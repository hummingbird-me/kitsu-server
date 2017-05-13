require 'rails_helper'

RSpec.describe ListImport::MyAnimeList::Row do
  context 'with anime' do
    let(:anime) { fixture('list_import/my_anime_list/toy-anime.json') }

    describe '#started_at' do
      context 'with empty date' do
        it 'should return nil' do
          subject = described_class.new(JSON.parse(anime)[1])
          expect(subject.started_at).to be_nil
        end
      end
      context 'with valid date' do
        it 'should return a date object' do
          subject = described_class.new(JSON.parse(anime)[0])
          expect(subject.started_at).to eq(DateTime.new(2016, 7, 23))
        end
      end
    end

    describe '#finished_at' do
      context 'with empty date' do
        it 'should return nil' do
          subject = described_class.new(JSON.parse(anime)[1])
          expect(subject.finished_at).to be_nil
        end
      end
      context 'with valid date' do
        it 'should return a date object' do
          subject = described_class.new(JSON.parse(anime)[0])
          expect(subject.finished_at).to eq(DateTime.new(2016, 7, 23))
        end
      end
    end
  end
end

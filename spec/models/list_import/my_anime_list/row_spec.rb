require 'rails_helper'

RSpec.describe ListImport::MyAnimeList::Row do
  let(:anime) { fixture('list_import/my_anime_list/toy-anime.json') }
  date_format = '%m-%d-%y'

  context 'with anime' do
    describe '#started_at' do
      context 'with empty date' do
        subject { described_class.new(JSON.parse(anime)[1], date_format) }
        it 'should return nil' do
          expect(subject.started_at).to be_nil
        end
      end
      context 'with valid date' do
        subject { described_class.new(JSON.parse(anime)[0], date_format) }
        it 'should return a date object' do
          expect(subject.started_at).to eq(DateTime.new(2016, 7, 23))
        end
      end
    end

    describe '#finished_at' do
      context 'with empty date' do
        subject { described_class.new(JSON.parse(anime)[1], date_format) }
        it 'should return nil' do
          expect(subject.finished_at).to be_nil
        end
      end
      context 'with valid date' do
        subject { described_class.new(JSON.parse(anime)[0], date_format) }
        it 'should return a date object' do
          expect(subject.finished_at).to eq(DateTime.new(2016, 7, 23))
        end
      end
    end
  end
end

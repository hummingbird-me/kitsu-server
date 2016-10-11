require 'rails_helper'

RSpec.describe Feed::ActivityList, type: :model do
  let(:list) { Feed::ActivityList.new(Feed.new('user', '1')) }
  subject { list }

  describe '#page' do
    context 'with a page number' do
      subject { list.page(1) }
      it 'should set the page_number' do
        expect(subject.page_number).to eq(1)
      end
    end
    context 'with an id_lt' do
      subject { list.page(id_lt: '12345') }
      it 'should set the id_lt on the query' do
        expect(subject.data).to have_key(:id_lt)
      end
    end
  end

  describe '#per' do
    subject { list.per(10) }
    it 'should set the page_size attribute' do
      expect(subject.page_size).to eq(10)
    end
  end

  describe 'combining #per and #page' do
    subject { list.per(10).page(5) }
    it 'should set the offset in the query' do
      expect(subject.data[:offset]).to eq(40)
    end
    it 'should set the limit in the query' do
      expect(subject.data[:limit]).to eq(10)
    end
  end
end

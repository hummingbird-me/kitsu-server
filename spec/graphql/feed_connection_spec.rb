# frozen_string_literal: true

RSpec.describe FeedConnection do
  let!(:stories) do
    create_list(:story, 10).sort_by(&:bumped_at).reverse
  end
  let(:query) { GraphQL::Query.new(KitsuSchema, '{ __typename }') }
  let(:context) { query.context }

  def encode(value)
    KitsuSchema.cursor_encoder.encode(value.strftime('%s.%6N'), nonce: true)
  end

  context 'with no cursor' do
    context 'and a limit of 5' do
      let(:connection) { described_class.new(Story.all, first: 5, context:) }

      it 'returns the first 5 records' do
        expect(connection.nodes.map(&:id)).to eq(stories[0...5].map(&:id))
      end

      it 'has a next page' do
        expect(connection.has_next_page).to be(true)
      end

      it 'does not have a previous page' do
        expect(connection.has_previous_page).to be(false)
      end
    end
  end

  context 'with an after cursor (forward pagination)' do
    let(:connection) do
      described_class.new(Story.all, first: 5, after: encode(stories[2].bumped_at), context:)
    end

    it 'returns the next 5 records' do
      expect(connection.nodes.map(&:id)).to eq(stories[3...8].map(&:id))
    end

    it 'has a next page' do
      expect(connection.has_next_page).to be(true)
    end

    it 'has a previous page' do
      expect(connection.has_previous_page).to be(true)
    end

    context 'at the end of the list' do
      let(:connection) do
        described_class.new(Story.all, first: 5, after: encode(stories[7].bumped_at), context:)
      end

      it 'returns the correct records' do
        expect(connection.nodes.map(&:id)).to eq(stories[8..].map(&:id))
      end

      it 'does not have a next page' do
        expect(connection.has_next_page).to be(false)
      end

      it 'has a previous page' do
        expect(connection.has_previous_page).to be(true)
      end
    end
  end

  context 'with a before cursor (backward pagination)' do
    let(:connection) do
      described_class.new(Story.all, last: 5, before: encode(stories[7].bumped_at), context:)
    end

    it 'returns the previous 5 records' do
      expect(connection.nodes.map(&:id)).to eq(stories[2...7].map(&:id))
    end

    it 'has a next page' do
      expect(connection.has_next_page).to be(true)
    end

    it 'has a previous page' do
      expect(connection.has_previous_page).to be(true)
    end

    context 'at the start of the list' do
      let(:connection) do
        described_class.new(Story.all, last: 5, before: encode(stories[3].bumped_at), context:)
      end

      it 'returns the previous 5 records' do
        expect(connection.nodes.map(&:id)).to eq(stories[0...3].map(&:id))
      end

      it 'has a next page' do
        expect(connection.has_next_page).to be(true)
      end

      it 'does not have a previous page' do
        expect(connection.has_previous_page).to be(false)
      end
    end
  end

  context 'with a first and last param' do
    it 'returns the last of the first' do
      connection = described_class.new(Story.all, first: 5, last: 3, context:)
      expect(connection.nodes.map(&:id)).to eq(stories[2...5].map(&:id))
    end
  end

  describe '#cursor_for' do
    let(:connection) { described_class.new(Story.all, first: 5, context:) }

    it 'returns a cursor for the given item' do
      cursor = connection.cursor_for(stories[2])
      expect(connection.send(:decode, cursor)).to eq(stories[2].bumped_at)
    end
  end
end

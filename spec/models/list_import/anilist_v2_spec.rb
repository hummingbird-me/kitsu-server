# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListImport::AnilistV2 do
  subject do
    described_class.create(
      input_text: 'toyhammered',
      user: build(:user)
    )
  end

  let(:media_lists) { JSON.parse(fixture('list_import/anilist_v2/toyhammered_full_list.json')).deep_transform_keys(&:underscore) }
  let(:client_double) { instance_double(GraphQL::Client) }

  before do
    allow(GraphQL::Client).to receive(:new) { client_double }
    allow(GraphQL::Client).to receive(:load_schema)
    allow(GraphQL::Client::HTTP).to receive(:new).with(described_class::GRAPHQL_API)

    allow(client_double).to receive(:parse)
    allow(client_double).to receive(:query) { JSON.parse(media_lists.to_json, object_class: OpenStruct) }
  end

  describe 'validations' do
    it { should validate_presence_of(:input_text) }
    it {
      should validate_length_of(:input_text)
        .is_at_least(3)
        .is_at_most(20)
    }
  end

  describe '#count' do
    it 'should return the total number of entries (combined)' do
      expect(subject.count).to eq(12)
    end
  end

  describe '#each' do
    let(:row_double) { instance_double(ListImport::AnilistV2::Row) }

    it 'should yield 12 times' do
      expect(ListImport::AnilistV2::Row).to receive(:new).at_least(:once) { row_double }
      expect(row_double).to receive(:media_mapping).at_least(:once)
      expect(row_double).to receive(:data).at_least(:once)

      expect { |b|
        subject.each(&b)
      }.to yield_control.exactly(12)
    end
  end
end

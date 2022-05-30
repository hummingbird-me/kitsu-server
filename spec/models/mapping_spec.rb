require 'rails_helper'

RSpec.describe Mapping, type: :model do
  subject { build(:mapping) }

  it { is_expected.to belong_to(:item).required }
  it { is_expected.to validate_presence_of(:external_site) }
  it { is_expected.to validate_presence_of(:external_id) }

  it do
    expect(subject).to validate_uniqueness_of(:item_id)
      .scoped_to(%i[item_type external_site])
  end

  describe '.lookup' do
    it 'responds when it finds the correct media' do
      anime = create(:anime)
      create(:mapping, item: anime, external_site: 'myanimelist',
        external_id: '17')
      expect(Mapping.lookup('myanimelist', '17')).to eq(anime)
    end

    it 'returns nil when it cannot find a matching media' do
      expect(Mapping.lookup('fakesite', '23')).to be_nil
    end
  end

  describe '.guess' do
    it 'responds with nil when it cannot find a reasonable match' do
      allow(AlgoliaMediaIndex).to receive(:search).and_return([])
      expect(Mapping.guess(Anime, title: 'Such Ass Ohmy')).to be_nil
    end
  end
end

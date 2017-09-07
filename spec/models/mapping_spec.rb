# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, item_type, item_id]
#  item_type     :string           not null, indexed => [external_site, external_id, item_id]
#  created_at    :datetime
#  updated_at    :datetime
#  external_id   :string           not null, indexed => [external_site, item_type, item_id]
#  item_id       :integer          not null, indexed => [external_site, external_id, item_type]
#
# Indexes
#
#  index_mappings_on_external_and_item  (external_site,external_id,item_type,item_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Mapping, type: :model do
  subject { build(:mapping) }
  it { should belong_to(:item) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:external_site) }
  it { should validate_presence_of(:external_id) }
  it do
    expect(subject).to validate_uniqueness_of(:item_id)
      .scoped_to(%i[item_type external_site])
  end

  describe '.lookup' do
    it 'should respond when it finds the correct media' do
      anime = create(:anime)
      create(:mapping, item: anime, external_site: 'myanimelist',
                       external_id: '17')
      expect(Mapping.lookup('myanimelist', '17')).to eq(anime)
    end
    it 'should return nil when it cannot find a matching media' do
      expect(Mapping.lookup('fakesite', '23')).to be_nil
    end
  end

  describe '.guess_algolia' do
    it 'should respond with nil when it cannot find a reasonable match' do
      expect(Mapping.guess_algolia(Anime, 'Such Ass Ohmy')).to be_nil
    end
  end
end

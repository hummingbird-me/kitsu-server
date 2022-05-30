require 'rails_helper'

RSpec.describe Titleable do
  let(:klass) do
    Class.new do
      include ActiveModel::Model
      include Titleable
      attr_accessor :titles, :original_languages, :original_countries

      def initialize(canonical_title: nil, **data)
        @data = { **data, canonical_title: canonical_title }
        super(data)
      end

      def [](key)
        @data[key]
      end

      def self.name
        'TitleableTest'
      end
    end
  end

  it 'validates that an english title is present' do
    expect(klass.new(titles: {
      'en' => 'March comes in like a lion'
    }, canonical_title: 'en')).to be_valid
    expect(klass.new(titles: { 'en_jp' => '3-gatsu no Lion' },
      canonical_title: 'en_jp')).to be_valid
    expect(klass.new(titles: { 'ja_jp' => '3月のライオン' }, canonical_title: 'ja_jp')).not_to be_valid
  end

  describe '#titles_list' do
    it 'returns a valid TitlesList object' do
      expect(klass.new(
        titles: {},
        canonical_title: :xx
      ).titles_list).to be_a(TitlesList)
    end
  end
end

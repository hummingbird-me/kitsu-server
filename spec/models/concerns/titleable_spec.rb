require 'rails_helper'

RSpec.describe Titleable do
  let(:klass) do
    Class.new do
      include ActiveModel::Model
      include Titleable
      attr_accessor :titles, :original_languages, :original_countries

      def initialize(canonical_title: nil, original_title: nil, romanized_title: nil, **data)
        @data = { canonical_title:, original_title:, romanized_title:, **data }
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
    expect(klass.new(titles: { 'en_jp' => '3-gatsu no Lion' }, canonical_title: 'en_jp')).to be_valid
    expect(klass.new(titles: { 'ja_jp' => '3月のライオン' }, canonical_title: 'ja_jp')).not_to be_valid
  end

  it 'validates that the romanized_title is present if a key is specified' do
    expect(klass.new(titles: {
      'en_jp' => '3-gatsu no Lion'
    }, canonical_title: 'en_jp', romanized_title: 'en_jp')).to be_valid

    expect(klass.new(titles: {
      'en' => 'March comes in like a lion'
    }, canonical_title: 'en', romanized_title: 'en_jp')).not_to be_valid
  end

  it 'validates that the original_title is present if a key is specified' do
    expect(klass.new(titles: {
      'ja_jp' => '3月のライオン',
      'en' => 'March comes in like a lion'
    }, canonical_title: 'ja_jp', original_title: 'ja_jp')).to be_valid
    expect(klass.new(titles: {
      'en' => 'March comes in like a lion'
    }, canonical_title: 'en', original_title: 'ja_jp')).not_to be_valid
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

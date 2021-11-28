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
    expect(klass.new(titles: { 'en_jp' => '3-gatsu no Lion' }, canonical_title: 'en_jp')).to be_valid
    expect(klass.new(titles: { 'ja_jp' => '3月のライオン' }, canonical_title: 'ja_jp')).not_to be_valid
  end

  describe '#canonical_title_key' do
    it 'returns whatever is set in the record' do
      expect(klass.new(canonical_title: 'en').canonical_title_key).to eq('en')
    end
  end

  describe '#canonical_title' do
    it 'returns the title specified by #canonical_title_key' do
      expect(klass.new(titles: {
        'en' => 'March comes in like a lion'
      }, canonical_title: 'en').canonical_title).to eq('March comes in like a lion')
    end
  end

  describe '#romanized_title_key' do
    it 'returns en_cn if present' do
      expect(klass.new(titles: {
        'en_cn' => 'Transliterated from Chinese',
        'en_jp' => 'Transliterated from Japanese'
      }).romanized_title_key).to eq('en_cn')
    end

    it 'returns en_kr if en_cr is not present' do
      expect(klass.new(titles: {
        'en_kr' => 'Transliterated from Korean',
        'en_jp' => 'Transliterated from Japanese'
      }).romanized_title_key).to eq('en_kr')
    end

    it 'returns en_jp if no other conditions are met' do
      expect(klass.new(titles: {
        'en_jp' => 'Transliterated from Japanese'
      }).romanized_title_key).to eq('en_jp')
    end
  end

  describe '#romanized_title' do
    it 'returns the title specified by #romanized_title_key' do
      titleable = klass.new(titles: {
        'en_jp' => 'Transliterated from Japanese'
      })

      expect(titleable.romanized_title).to eq('Transliterated from Japanese')
      expect(titleable.romanized_title_key).to eq('en_jp')
    end
  end

  describe '#original_title_key' do
    it 'returns the original language+country if there is a title for it' do
      titleable = klass.new(titles: {
        'zh_cn' => 'Chinese'
      }, original_languages: ['zh'], original_countries: ['cn'])

      expect(titleable.original_title_key).to eq('zh_cn')
    end

    it 'returns ja_jp when that exists' do
      titleable = klass.new(titles: {
        'ja_jp' => 'Japanese'
      }, original_languages: [], original_countries: [])

      expect(titleable.original_title_key).to eq('ja_jp')
    end
  end

  describe '#original_title' do
    it 'returns the title specified by #original_title_key' do
      titleable = klass.new(titles: {
        'ja_jp' => 'Japanese'
      }, original_languages: [], original_countries: [])

      expect(titleable.original_title).to eq('Japanese')
      expect(titleable.original_title_key).to eq('ja_jp')
    end
  end

  describe '#localized_title_key' do
    it 'returns an exact match for your current locale' do
      I18n.with_locale(:en_gb) do
        # It's okay to tease the brits a little
        expect(klass.new(titles: {
          'en_gb' => 'Oine Poice (in a ridiculous cockney accent)'
        }).localized_title_key).to eq('en_gb')
      end
    end

    it 'returns a language-only match for your locale' do
      I18n.with_locale(:en_gb) do
        expect(klass.new(titles: {
          'en' => 'One Piece'
        }).localized_title_key).to eq('en')
      end
    end

    it 'will not pick up a title from a different country' do
      I18n.with_locale(:en_gb) do
        # Let's tease the americans too
        expect(klass.new(titles: {
          'en_us' => 'GUN PIECE'
        }).localized_title_key).to be_nil
      end
    end
  end

  describe '#localized_title' do
    it 'returns the title specified by #localized_title_key' do
      I18n.with_locale(:en) do
        titleable = klass.new(titles: {
          'en' => 'One Piece'
        })

        expect(titleable.localized_title).to eq('One Piece')
        expect(titleable.localized_title_key).to eq('en')
      end
    end
  end

  describe '#first_title_for(list)' do
    it 'returns the first available title of the list' do
      titleable = klass.new(titles: {
        'en' => "Yumi's Cells",
        'ko_kr' => '유미의 세포들'
      }, canonical_title: 'en', original_languages: ['ko'], original_countries: ['kr'])

      expect(titleable.first_title_for(%w[romanized canonical original])).to eq("Yumi's Cells")
      expect(titleable.first_title_for(%i[original romanized canonical])).to eq('유미의 세포들')
    end
  end
end

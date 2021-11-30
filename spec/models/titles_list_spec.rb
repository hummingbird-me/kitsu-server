require 'rails_helper'

RSpec.describe TitlesList do
  describe '#canonical_locale' do
    it 'returns whatever is set in the record' do
      expect(described_class.new(
        titles: {},
        canonical_locale: :en
      ).canonical_locale).to eq(:en)
    end
  end

  describe '#canonical' do
    it 'returns the title specified by #canonical_locale' do
      expect(described_class.new(titles: {
        en: 'March comes in like a lion'
      }, canonical_locale: :en).canonical).to eq('March comes in like a lion')
    end
  end

  describe '#romanized_locale' do
    it 'returns en_cn if present' do
      expect(described_class.new(titles: {
        en_cn: 'Transliterated from Chinese',
        en_jp: 'Transliterated from Japanese'
      }, canonical_locale: :junk).romanized_locale).to eq(:en_cn)
    end

    it 'returns en_kr if en_cr is not present' do
      expect(described_class.new(titles: {
        en_kr: 'Transliterated from Korean',
        en_jp: 'Transliterated from Japanese'
      }, canonical_locale: :junk).romanized_locale).to eq(:en_kr)
    end

    it 'returns en_jp if no other conditions are met' do
      expect(described_class.new(titles: {
        en_jp: 'Transliterated from Japanese'
      }, canonical_locale: :junk).romanized_locale).to eq(:en_jp)
    end
  end

  describe '#romanized' do
    it 'returns the title specified by #romanized_locale' do
      titleable = described_class.new(titles: {
        en_jp: 'Transliterated from Japanese'
      }, canonical_locale: :junk)

      expect(titleable.romanized).to eq('Transliterated from Japanese')
      expect(titleable.romanized_locale).to eq(:en_jp)
    end
  end

  describe '#original_locale' do
    it 'returns the original language+country if there is a title for it' do
      titleable = described_class.new(titles: {
        zh_cn: 'Chinese'
      }, original_languages: ['zh'], original_countries: ['cn'], canonical_locale: :junk)

      expect(titleable.original_locale).to eq(:zh_cn)
    end

    it 'returns ja_jp when that exists' do
      titleable = described_class.new(titles: {
        ja_jp: 'Japanese'
      }, original_languages: [], original_countries: [], canonical_locale: :junk)

      expect(titleable.original_locale).to eq(:ja_jp)
    end
  end

  describe '#original' do
    it 'returns the title specified by #original_locale' do
      titleable = described_class.new(titles: {
        ja_jp: 'Japanese'
      }, original_languages: [], original_countries: [], canonical_locale: :junk)

      expect(titleable.original).to eq('Japanese')
      expect(titleable.original_locale).to eq(:ja_jp)
    end
  end

  describe '#translated_locale' do
    it 'returns an exact match for your current locale' do
      I18n.with_locale(:en_gb) do
        # It's okay to tease the brits a little
        expect(described_class.new(titles: {
          en_gb: 'Oine Poice (in a ridiculous cockney accent)'
        }, canonical_locale: :junk).translated_locale).to eq(:en_gb)
      end
    end

    it 'returns a language-only match for your locale' do
      I18n.with_locale(:en_gb) do
        expect(described_class.new(titles: {
          en: 'One Piece'
        }, canonical_locale: :junk).translated_locale).to eq(:en)
      end
    end

    it 'will not pick up a title from a different country' do
      I18n.with_locale(:en_gb) do
        # Let's tease the americans too
        expect(described_class.new(titles: {
          en_us: 'GUN PIECE'
        }, canonical_locale: :junk).translated_locale).to be_nil
      end
    end
  end

  describe '#translated' do
    it 'returns the title specified by #translated_locale' do
      I18n.with_locale(:en) do
        titleable = described_class.new(titles: {
          en: 'One Piece'
        }, canonical_locale: :junk)

        expect(titleable.translated).to eq('One Piece')
        expect(titleable.translated_locale).to eq(:en)
      end
    end
  end

  describe '#first_title_for(list)' do
    it 'returns the first available title of the list' do
      titleable = described_class.new(titles: {
        en: "Yumi's Cells",
        ko_kr: '유미의 세포들'
      }, canonical_locale: :en, original_languages: ['ko'], original_countries: ['kr'])

      expect(titleable.first_title_for(%i[romanized canonical original])).to eq("Yumi's Cells")
      expect(titleable.first_title_for(%i[original romanized canonical])).to eq('유미의 세포들')
    end
  end
end

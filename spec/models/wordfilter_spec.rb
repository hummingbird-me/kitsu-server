require 'rails_helper'

RSpec.describe Wordfilter do
  it { is_expected.to validate_presence_of(:pattern) }

  describe '.matching(text)' do
    context 'when regex_enabled = true' do
      it 'matches like a regular expression' do
        filter = create(:wordfilter, pattern: 'fee+t', regex_enabled: true)

        expect(described_class.matching('feeeeeeeeeeeet').first).to eq(filter)
      end

      it 'matches case insensitively' do
        filter = create(:wordfilter, pattern: 'fee+t', regex_enabled: true)

        expect(described_class.matching('FEEEEEET').first).to eq(filter)
      end

      it 'matches anywhere in the text' do
        filter = create(:wordfilter, pattern: 'fee+t', regex_enabled: true)

        expect(described_class.matching('she got dem feeeet').first).to eq(filter)
      end

      it 'does not return exact matches' do
        create(:wordfilter, pattern: 'fee+t', regex_enabled: true)

        expect(described_class.matching('fee+t')).to be_empty
      end

      it 'matches word boundaries' do
        filter = create(:wordfilter, pattern: '\btest\b', regex_enabled: true)

        expect(described_class.matching('this is a test').first).to eq(filter)
        expect(described_class.matching('thisisatestofthings')).to be_empty
      end
    end

    context 'when regex_enabled = false' do
      it 'matches with LIKE patterns' do
        filter = create(:wordfilter, pattern: 'f__t', regex_enabled: false)

        expect(described_class.matching('foot').first).to eq(filter)
      end

      it 'matches case insensitively' do
        filter = create(:wordfilter, pattern: 'feet', regex_enabled: false)

        expect(described_class.matching('FEET').first).to eq(filter)
      end

      it 'matches anywhere in the text' do
        filter = create(:wordfilter, pattern: 'feet', regex_enabled: false)

        expect(described_class.matching('she got dem feet yo').first).to eq(filter)
      end
    end
  end

  describe '.action_for(location, text)' do
    it 'returns the most-severe action which applies' do
      create(:wordfilter, pattern: 'feet', action: :report, locations: %i[post])
      create(:wordfilter, pattern: 'slur', action: :reject, locations: %i[post])

      expect(described_class.action_for(:post, 'feet is a slur')).to eq(:reject)
    end

    it 'only finds wordfilters for a given location' do
      create(:wordfilter, pattern: 'feet', action: :report, locations: %i[post])
      create(:wordfilter, pattern: 'suck', action: :reject, locations: %i[reaction])

      expect(described_class.action_for(:post, 'feet suck, fools')).to eq(:report)
    end
  end
end

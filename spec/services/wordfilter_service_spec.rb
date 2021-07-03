require 'rails_helper'

RSpec.describe WordfilterService do
  context 'with only a reject wordfilter' do
    before do
      create(:wordfilter, action: :reject, pattern: 'test', locations: %i[post])
    end

    let(:service) { described_class.new(:post, 'this is a test post') }

    describe '#reject?' do
      it('returns true') { expect(service).to be_reject }
    end

    describe '#hide?' do
      it('returns false') { expect(service).not_to be_hide }
    end
  end

  context 'with reject and hide wordfilters' do
    before do
      create(:wordfilter, action: :reject, pattern: 'test', locations: %i[post])
      create(:wordfilter, action: :hide, pattern: 'post', locations: %i[post])
    end

    let(:service) { described_class.new(:post, 'this is a test post') }

    describe '#reject?' do
      it('returns true') { expect(service).to be_reject }
    end

    describe '#hide?' do
      it('returns true') { expect(service).to be_hide }
    end
  end

  context 'with basic censor wordfilter' do
    before do
      create(:wordfilter, action: :censor, pattern: 'options', locations: %i[post])
    end

    let(:service) { described_class.new(:post, 'we should add some options') }

    describe '#censor?' do
      it('returns true') { expect(service).to be_censor }
    end

    describe '#censored_text' do
      it 'returns the content with censorship applied' do
        expect(service.censored_text).to eq('we should add some CENSORED')
      end
    end
  end

  context 'with LIKE censor wordfilter' do
    before do
      create(:wordfilter, action: :censor, pattern: 'j_sh', locations: %i[post])
    end

    let(:service) { described_class.new(:post, 'praise josh') }

    describe '#censor?' do
      it('returns true') { expect(service).to be_censor }
    end

    describe '#censored_text' do
      it 'returns the content with censorship applied' do
        expect(service.censored_text).to eq('praise CENSORED')
      end
    end
  end

  context 'with multiple regex censor wordfilters' do
    before do
      create(:wordfilter,
        action: :censor,
        pattern: 'we*abo*',
        locations: %i[post],
        regex_enabled: true)
      create(:wordfilter,
        action: :censor,
        pattern: 'b(i|eeyo)tch',
        locations: %i[post],
        regex_enabled: true)
    end

    let(:service) { described_class.new(:post, 'you are a WEEABOO bitch') }

    describe '#censor?' do
      it('returns true') { expect(service).to be_censor }
    end

    describe '#censored_text' do
      it 'returns the content with censorship applied' do
        expect(service.censored_text).to eq('you are a CENSORED CENSORED')
      end
    end
  end
end

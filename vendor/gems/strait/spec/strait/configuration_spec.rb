# frozen_string_literal: true

require 'strait/configuration'

RSpec.describe Strait::Configuration do
  describe '#[]' do
    it 'should return the configuration set for that field' do
      config = described_class.new(redis: { url: 'test' })
      expect(config[:redis]).to eq(url: 'test')
    end
  end

  describe '#[]=' do
    it 'should set the configuration for the field' do
      config = described_class.new(redis: { url: 'test' })
      expect {
        config[:redis] = { url: 'new!' }
      }.to(change { config[:redis] })
    end
  end

  describe '#merge' do
    it 'should return a new instance with modified config' do
      config = described_class.new(redis: { url: 'test' })
      new_config = config.merge(redis: { url: 'new!' })
      expect(new_config[:redis][:url]).not_to eq(config[:redis][:url])
      expect(new_config[:redis][:url]).to eq('new!')
    end

    it 'should return itself when an empty object is passed' do
      old_config = described_class.new(redis: { url: 'test' })
      new_config = old_config.merge({})
      expect(new_config).to be(old_config)
    end

    it 'should return itself when nil is passed' do
      old_config = described_class.new(redis: { url: 'test' })
      new_config = old_config.merge(nil)
      expect(new_config).to be(old_config)
    end
  end

  describe '.default' do
    it 'should allow setting a global default' do
      described_class.default = 'foo'
      expect(described_class.default).to eq('foo')
    end
  end
end

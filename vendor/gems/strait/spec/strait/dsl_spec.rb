# frozen_string_literal: true

require 'strait/dsl'

RSpec.describe Strait::DSL do
  describe '#limit' do
    it 'should add rules to the list' do
      dsl = described_class.new do
        limit 5, per: 60, buckets: 60
      end
      expect(dsl.rules.count).to eq(1)
    end

    it 'should create rules with the right structure' do
      dsl = described_class.new do
        limit 5, per: 60, buckets: 6
      end
      expect(dsl.rules.last).to eq(count: 5, period: 60, buckets: 6)
    end

    it 'should default to 60 buckets per period' do
      dsl = described_class.new do
        limit 5, per: 60
      end
      expect(dsl.rules.last[:buckets]).to eq(60)
    end
  end
end

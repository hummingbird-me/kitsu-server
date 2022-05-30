require 'rails_helper'

RSpec.describe AppleReceiptService::Error do
  describe '#for_code' do
    it 'returns InvalidJSON for 21000' do
      expect(described_class.for_code(21_000)).to eq(
        AppleReceiptService::Error::InvalidJSON
      )
    end

    it 'returns MalformedReceipt for 21002' do
      expect(described_class.for_code(21_002)).to eq(
        AppleReceiptService::Error::MalformedReceipt
      )
    end

    it 'returns UnauthenticatedReceipt for 21003' do
      expect(described_class.for_code(21_003)).to eq(
        AppleReceiptService::Error::UnauthenticatedReceipt
      )
    end

    it 'returns InvalidSecret for 21004' do
      expect(described_class.for_code(21_004)).to eq(
        AppleReceiptService::Error::InvalidSecret
      )
    end

    it 'returns ServerUnavailable for 21005' do
      expect(described_class.for_code(21_005)).to eq(
        AppleReceiptService::Error::ServerUnavailable
      )
    end

    it 'returns TestReceiptOnProduction for 21007' do
      expect(described_class.for_code(21_007)).to eq(
        AppleReceiptService::Error::TestReceiptOnProduction
      )
    end

    it 'returns ProductionReceiptOnTest for 21008' do
      expect(described_class.for_code(21_008)).to eq(
        AppleReceiptService::Error::ProductionReceiptOnTest
      )
    end

    it 'returns UnauthorizedReceipt for 21010' do
      expect(described_class.for_code(21_010)).to eq(
        AppleReceiptService::Error::UnauthorizedReceipt
      )
    end

    it 'returns InternalError for 21100' do
      expect(described_class.for_code(21_100)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end

    it 'returns InternalError for 21150' do
      expect(described_class.for_code(21_150)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end

    it 'returns InternalError for 21199' do
      expect(described_class.for_code(21_199)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end
  end

  it 'subclasses StandardError' do
    expect(described_class).to be < StandardError
  end
end

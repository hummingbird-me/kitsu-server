require 'rails_helper'

RSpec.describe AppleReceiptService::Error do
  describe '#for_code' do
    it 'should return InvalidJSON for 21000' do
      expect(AppleReceiptService::Error.for_code(21_000)).to eq(
        AppleReceiptService::Error::InvalidJSON
      )
    end
    it 'should return MalformedReceipt for 21002' do
      expect(AppleReceiptService::Error.for_code(21_002)).to eq(
        AppleReceiptService::Error::MalformedReceipt
      )
    end
    it 'should return UnauthenticatedReceipt for 21003' do
      expect(AppleReceiptService::Error.for_code(21_003)).to eq(
        AppleReceiptService::Error::UnauthenticatedReceipt
      )
    end
    it 'should return InvalidSecret for 21004' do
      expect(AppleReceiptService::Error.for_code(21_004)).to eq(
        AppleReceiptService::Error::InvalidSecret
      )
    end
    it 'should return ServerUnavailable for 21005' do
      expect(AppleReceiptService::Error.for_code(21_005)).to eq(
        AppleReceiptService::Error::ServerUnavailable
      )
    end
    it 'should return TestReceiptOnProduction for 21007' do
      expect(AppleReceiptService::Error.for_code(21_007)).to eq(
        AppleReceiptService::Error::TestReceiptOnProduction
      )
    end
    it 'should return ProductionReceiptOnTest for 21008' do
      expect(AppleReceiptService::Error.for_code(21_008)).to eq(
        AppleReceiptService::Error::ProductionReceiptOnTest
      )
    end
    it 'should return UnauthorizedReceipt for 21010' do
      expect(AppleReceiptService::Error.for_code(21_010)).to eq(
        AppleReceiptService::Error::UnauthorizedReceipt
      )
    end
    it 'should return InternalError for 21100' do
      expect(AppleReceiptService::Error.for_code(21_100)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end
    it 'should return InternalError for 21150' do
      expect(AppleReceiptService::Error.for_code(21_150)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end
    it 'should return InternalError for 21199' do
      expect(AppleReceiptService::Error.for_code(21_199)).to eq(
        AppleReceiptService::Error::InternalError
      )
    end
  end

  it 'should subclass StandardError' do
    expect(AppleReceiptService::Error).to be < StandardError
  end
end

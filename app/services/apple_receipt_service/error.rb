class AppleReceiptService
  class Error < StandardError
    class InvalidJSON < Error; end
    class MalformedReceipt < Error; end
    class UnauthenticatedReceipt < Error; end
    class InvalidSecret < Error; end
    class ServerUnavailable < Error; end
    class TestReceiptOnProduction < Error; end
    class ProductionReceiptOnTest < Error; end
    class UnauthorizedReceipt < Error; end
    class InternalError < Error; end

    def self.for_code(code)
      # rubocop:disable Style/NumericLiterals
      case code
      when 21000 then InvalidJSON
      when 21002 then MalformedReceipt
      when 21003 then UnauthenticatedReceipt
      when 21004 then InvalidSecret
      when 21005 then ServerUnavailable
      when 21007 then TestReceiptOnProduction
      when 21008 then ProductionReceiptOnTest
      when 21010 then UnauthorizedReceipt
      when 21100..21199 then InternalError
      end
      # rubocop:enable Style/NumericLiterals
    end
  end
end

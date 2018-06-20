class AppleReceiptService
  VERIFICATION_URL = ENV['APPLE_VERIFICATION_URL']
  SECRET = ENV['APPLE_VERIFICATION_SECRET']

  def initialize(receipt)
    @receipt = receipt
    raise AppleReceiptService::Error.for_code(verification_response['status']) unless receipt_valid?
  end

  def start_date
    Time.rfc3339(latest_receipt_info['purchase_date'])
  end

  def end_date
    Time.rfc3339(latest_receipt_info['expires_date'])
  end

  def billing_id
    latest_receipt_info['original_transaction_id']
  end

  private

  def latest_receipt_info
    verification_response['latest_receipt_info']
  end

  def receipt_valid?
    verification_response['status']&.zero?
  end

  def verification_payload
    @verification_payload ||= {
      'receipt-data' => @receipt,
      'password' => SECRET,
      'exclude-old-transactions' => true
    }
  end

  def verification_response
    @verification_response ||= http.post(VERIFICATION_URL, verification_payload).body
  end

  def http
    @http ||= Faraday.new do |builder|
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
    end
  end
end

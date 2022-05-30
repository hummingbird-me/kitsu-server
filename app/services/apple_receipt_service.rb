class AppleReceiptService
  VERIFICATION_URL = ENV.fetch('APPLE_VERIFICATION_URL', nil)
  SECRET = ENV.fetch('APPLE_VERIFICATION_SECRET', nil)

  def initialize(receipt)
    @receipt = receipt
    raise AppleReceiptService::Error.for_code(verification_response['status']) unless receipt_valid?
  end

  def start_date
    DateTime.rfc3339(latest_receipt_info['purchase_date']).to_time
  end

  def end_date
    DateTime.rfc3339(latest_receipt_info['expires_date']).to_time
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
      builder.adapter Faraday.default_adapter
    end
  end
end

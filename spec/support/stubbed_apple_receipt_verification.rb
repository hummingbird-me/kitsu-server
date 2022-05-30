RSpec.shared_context 'Stubbed Apple Receipt Verification' do
  subject { described_class.new('fake_receipt') }

  let(:verify_url) { 'http://example.com/receipt-verify' }
  before do
    require 'apple_receipt_service'
    stub_const('AppleReceiptService::VERIFICATION_URL', verify_url)
  end

  def stub_receipt_verification(latest_receipt_info: {}, status: 0)
    response = { status: status, latest_receipt_info: latest_receipt_info }.to_json
    stub_request(:post, verify_url).to_return(
      status: 200,
      body: response,
      headers: {
        'Content-Type' => 'application/json',
        'Content-Length' => response.length
      }
    )
  end
end

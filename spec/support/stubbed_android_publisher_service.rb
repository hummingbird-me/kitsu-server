RSpec.shared_context 'Stubbed Android Publisher Service' do
  class AndroidPublisherService < Google::Apis::AndroidpublisherV3::AndroidPublisherService
    def self.new
      @new ||= super
    end
  end

  let(:api) { AndroidPublisherService.new }

  before do
    stub_const('Google::Apis::AndroidpublisherV3::AndroidPublisherService', AndroidPublisherService)
  end
end

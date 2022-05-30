require 'stripe_mock'

RSpec.configure do |config|
  config.before do |test|
    StripeMock.start unless test.metadata[:live_stripe]
  end
  config.after do |test|
    StripeMock.stop unless test.metadata[:live_stripe]
  end
end

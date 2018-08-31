require 'stripe_mock'

RSpec.configure do |config|
  config.before(:example) do |test|
    StripeMock.start unless test.metadata[:live_stripe]
  end
  config.after(:example) do |test|
    StripeMock.stop unless test.metadata[:live_stripe]
  end
end

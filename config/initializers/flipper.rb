require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.default do
    # Connect to Redis and initialize Flipper
    adapter = Flipper::Adapters::Redis.new(Redis.connect)
    Flipper.new(adapter)
  end
end

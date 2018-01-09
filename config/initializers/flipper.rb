require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.default do
    # Connect to Redis and initialize Flipper
    adapter = Flipper::Adapters::Redis.new(Redis.new)
    Flipper.new(adapter)
  end
end

Flipper.register(:staff) do |user|
  user.try(:has_role?, :admin)
end

Flipper.register(:pro) do |user|
  user.try(:pro?)
end

Flipper.register(:mod) do |user|
  user.try(:has_role?, :mod) || user.try(:has_role?, :admin, Anime)
end

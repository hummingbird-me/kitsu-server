require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.default do
    # Connect to Redis and initialize Flipper
    adapter = Flipper::Adapters::Redis.new(Redis.new)
    Flipper.new(adapter)
  end
end

Flipper.register(:staff) do |user|
  user&.permissions&.admin?
end

Flipper.register(:pro) do |user|
  user&.pro?
end

Flipper.register(:mod) do |user|
  user&.permissions&.community_mod? || user&.permissions&.database_mod?
end

Flipper.register(:aozora) do |user|
  user&.ao_id
end

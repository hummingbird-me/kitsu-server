HealthBit.configure do |config|
  config.add('Database Connection') do
    ApplicationRecord.connection.select_value('SELECT 1') == 1
  end
  config.add('Database Migrations') do
    ActiveRecord::Migration.check_pending! == nil
  end
  config.add('Redis Connection') do
    $redis.with { |r| r.ping == 'PONG' }
  end
end

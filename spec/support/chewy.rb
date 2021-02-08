require 'chewy/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # Commit changes to the index immediately
    Chewy.strategy(:bypass)
  end
  config.before(:example, elasticsearch: true) do
    Chewy.strategy(:urgent)
    Chewy.client.cluster.health wait_for_status: 'yellow', timeout: '10s'
    Chewy::Index.descendants.each(&:purge!)
    Chewy.client.cluster.health wait_for_status: 'yellow', timeout: '10s'
    # HACK: just fucking kill me
    sleep 0.1
  end
  config.after(:example, elasticsearch: true) do
    Chewy.strategy(:bypass)
  end
end

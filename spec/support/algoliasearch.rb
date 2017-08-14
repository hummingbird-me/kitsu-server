RSpec.configure do |config|
  config.before(:example) do
    load 'algolia/webmock.rb'
  end
end

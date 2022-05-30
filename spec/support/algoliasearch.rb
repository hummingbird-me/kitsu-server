RSpec.configure do |config|
  config.before do
    load 'algolia/webmock.rb'
  end
end

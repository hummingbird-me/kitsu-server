RSpec.configure do |config|
  config.before(:each) do |example|
    unless example.metadata[:stream_api]
      stub_request(:any, %r{https://api.stream-io-api.com/api/v1.0/})
        .and_return(status: 200, body: '{}')
      stub_request(:any, %r{https://api.getstream.io/api/v1.0/})
        .and_return(status: 200, body: '{}')
      stub_request(:any, %r{https://kitsu.getstream.io/})
        .to_return(status: 200, body: '{}')
    end
  end
end

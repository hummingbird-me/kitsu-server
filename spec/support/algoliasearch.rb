RSpec.configure do |config|
  # The Algolia v1 gem used to ship an `algolia/webmock.rb` helper that stubbed
  # all Algolia API traffic. The upgraded `algolia` 3.x gem no longer provides
  # it, so we stub the Algolia hosts directly to keep tests offline.
  config.before(:example) do
    stub_request(:any, /algolia(net)?\.(net|com)/).to_return(
      status: 200,
      headers: { 'Content-Type' => 'application/json' },
      body: {
        taskID: 1,
        objectID: 'stub',
        objectIDs: [],
        hits: [],
        results: [],
        nbHits: 0,
        page: 0,
        nbPages: 0
      }.to_json
    )
  end
end

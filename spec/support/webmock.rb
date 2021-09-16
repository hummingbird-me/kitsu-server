require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [
  'robohash.org',
  'codeclimate.com',
  %r{pigment.github.io/fake-logos},
  'lorempixel.com',
  'localhost',
  'elasticsearch:9200',
  'minio:9000',
  'oembed.com'
])

RSpec.shared_context 'MAL CDN' do
  before do
    stub_request(:get, %r{https://myanimelist.cdn-dena.com/.*})
      .to_return(body: fixture('image.png'))
  end
end

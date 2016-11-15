require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [
  'robohash.org',
  'codeclimate.com',
  %r{pigment.github.io/fake-logos},
  'localhost',
  'api.getstream.io',
  'elasticsearch:9200'
])

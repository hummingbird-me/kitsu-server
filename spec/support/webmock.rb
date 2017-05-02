require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [
  'robohash.org',
  'codeclimate.com',
  %r{pigment.github.io/fake-logos},
  'lorempixel.com',
  'localhost',
  'elasticsearch:9200'
])

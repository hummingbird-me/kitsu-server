require_dependency 'fake_stream/feed'

class FakeStream
  class Client
    def initialize(*); end

    def feed(group, id)
      FakeStream::Feed.new(group, id)
    end
  end
end

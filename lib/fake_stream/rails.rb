class FakeStream
  class Rails
    class << self
      def client
        FakeStream::Client.new
      end
    end
  end
end

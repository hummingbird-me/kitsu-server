require_dependency 'fake_stream/rails'

class FakeStream
  class_attribute :feeds

  class << self
    def feed(name, type)
      self.feeds ||= Hash.new({
        data: Hash.new({
          followers: [],
          following: [],
          activities: []
        }),
        type: type
      })
    end

    def configure(&block)
      instance_eval(&block)
    end

    def fake!
      Object.send(:remove_const, :StreamRails)
      Object.send(:remove_const, :Stream)
      Object.const_set(:StreamRails, FakeStream::Rails)
      Object.const_set(:Stream, FakeStream)
    end

    def fake?
      StreamRails == FakeStream::Rails && Stream == FakeStream
    end

    def feed_for(group, id)
      feeds[group.downcase][:data][id]
    end

    def activities_for(group, id)
      feed_for(group, id)[:activites]
    end

    def followers_for(group, id)
      feed_for(group, id)[:followers]
    end
  end
end

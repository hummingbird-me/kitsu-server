class Feed
  class SiteAnnouncementsFeed < Feed
    feed_type :notification

    def self.global
      new('global')
    end

    def setup!
      follow(self.class.global)
    end
  end
end

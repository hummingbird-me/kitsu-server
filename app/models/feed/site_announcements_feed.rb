class Feed
  class SiteAnnouncementsFeed < Feed
    feed_type :notification

    def setup!
      follow(SiteAnnouncementsGlobal.new)
    end
  end
end

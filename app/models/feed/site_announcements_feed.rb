class Feed
  class SiteAnnouncementsFeed < Feed
    feed_type :notification

    def setup!
      follow(SiteAnnouncementsGlobal.global)
    end
  end
end

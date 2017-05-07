class SiteAnnouncementsFeed < Feed
  feed_type :notification

  def setup!
    follow(SiteAnnouncementsGlobalFeed.new)
  end
end

class SiteAnnouncementsFeed < Feed
  def setup!
    follow(SiteAnnouncementsGlobalFeed.new)
  end
end

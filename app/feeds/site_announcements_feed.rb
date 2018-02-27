class SiteAnnouncementsFeed < Feed
  def setup!
    follow(SiteAnnouncementsGlobalFeed.new, scrollback: 1)
  end
end

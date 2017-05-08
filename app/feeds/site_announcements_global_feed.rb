class SiteAnnouncementsGlobalFeed < Feed
  feed_type :flat

  def initialize(*)
    super('global')
  end
end

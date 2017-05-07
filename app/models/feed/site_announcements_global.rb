class Feed
  class SiteAnnouncementsGlobal < Feed
    feed_type :flat

    def initialize
      super('global')
    end
  end
end

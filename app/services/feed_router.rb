# rubocop:disable Metrics/CyclomaticComplexity, Style/PerlBackrefs
class FeedRouter
  def self.route(group, id)
    case group
    # Media Pages
    when 'media', 'media_aggr'
      case id
      when /Anime-(\d+)/ then AnimeFeed.new($1)
      when /Manga-(\d+)/ then MangaFeed.new($1)
      end
    # Media Unit Pages
    when 'episode', 'episode_aggr' then EpisodeFeed.new(id)
    when 'chapter', 'chapter_aggr' then ChapterFeed.new(id)

    # Timelines
    when 'global' then GlobalFeed.new
    when 'timeline' then TimelineFeed.new(id)
    when 'interest_timeline'
      case id
      when /(\d+)-Anime/ then AnimeTimelineFeed.new($1)
      when /(\d+)-Manga/ then MangaTimelineFeed.new($1)
      end

    # Profiles
    when 'user', 'user_aggr' then ProfileFeed.new(id)

    # Notifications
    when 'notifications' then NotificationsFeed.new(id)
    when 'site_announcements' then SiteAnnouncementsFeed.new(id)

    # Groups
    when 'group', 'group_aggr' then GroupFeed.new(id)

    # Reports
    when 'reports' then ReportsFeed.new(id)
    end
  end
end

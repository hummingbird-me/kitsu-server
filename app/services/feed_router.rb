# rubocop:disable Metrics/CyclomaticComplexity, Style/PerlBackrefs
class FeedRouter
  def self.route(group, id)
    case group
    when 'media', 'media_aggr'
      case id
      when /Anime-(\d+)/ then AnimeFeed.new($1)
      when /Manga-(\d+)/ then MangaFeed.new($1)
      end
    when 'interest_timeline'
      case id
      when /(\d+)-Anime/ then AnimeTimelineFeed.new($1)
      when /(\d+)-Manga/ then MangaTimelineFeed.new($1)
      end
    when 'timeline' then TimelineFeed.new(id)
    when 'notifications' then NotificationsFeed.new(id)
    when 'global' then GlobalFeed.new
    when 'site_announcements' then SiteAnnouncementsFeed.new(id)
    when 'group', 'group_aggr' then GroupFeed.new(id)
    when 'reports' then ReportsFeed.new(id)
    when 'episode' then EpisodeFeed.new(id)
    when 'chapter' then ChapterFeed.new(id)
    end
  end
end

# Provides the Media-specific timelines.
#
# Media timelines are keyed on (user_id, media_type) and contain:
#   1. Posts global to the media_type (user_id=global)
#   2. Posts discussing things in your library (via MediaFollow)
#   3. Posts discussing units you've completed (via Episode/ChapterFeed)
class InterestTimelineFeed < Feed
  include UnsuffixedAggregatedFeed

  def self.global_for(interest)
    new('global', interest)
  end

  def self.global
    new('global')
  end

  def default_auto_follows
    global_follow = { source: stream_feed, target: self.class.global }
    [global_follow, *super]
  end
end

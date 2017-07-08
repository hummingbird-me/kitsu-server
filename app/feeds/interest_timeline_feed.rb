# Provides the Media-specific timelines.
#
# Media timelines are keyed on (user_id, media_type) and contain:
#   1. Posts global to the media_type (user_id=global)
#   2. Posts discussing things in your library (via MediaFollow)
#   3. Posts discussing units you've completed (via Episode/ChapterFeed)
class InterestTimelineFeed < Feed
  include UnsuffixedAggregatedFeed

  def self.global_for(interest)
    new(global, interest)
  end
end

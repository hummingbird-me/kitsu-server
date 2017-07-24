# Provides the Media-specific timelines.
#
# Media timelines are keyed on (user_id, media_type) and contain:
#   1. Posts global to the media_type (user_id=global)
#   2. Posts discussing things in your library (via MediaFollow)
#   3. Posts discussing units you've completed (via Episode/ChapterFeed)
class InterestTimelineFeed < Feed
  include UnsuffixedAggregatedFeed

  def self.for_interest(interest)
    "#{interest.classify}TimelineFeed".safe_constantize if interest
  end

  def self.global_for(interest)
    InterestGlobalFeed.new(interest)
  end

  def self.global
    media = name.sub(/TimelineFeed\z/, '')
    global_for(media)
  end

  def default_auto_follows
    global_follow = { source: stream_feed, target: self.class.global }
    [global_follow, *super]
  end

  # Either the progress_was or progress parameters can be nil to disable unfollowing or following,
  # respectively.
  def update_unit_follows(media, progress_was = nil, progress = nil)
    # Generate the previous and current unit sets
    # Unfollow more zealously than we follow, just for safety
    previous_units = follows_for_progress(media, progress_was, limit: 10) if progress_was
    new_units = follows_for_progress(media, progress) if progress

    # Don't unfollow just to refollow
    if progress_was
      previous_units -= new_units if progress
      unfollow_many(previous_units)
    end
    follow_many(new_units) if progress
  end
end

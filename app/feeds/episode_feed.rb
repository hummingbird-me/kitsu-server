class EpisodeFeed < Feed
  def self.follows_for_progress(media, progress)
    episode_ids = media.episodes.for_progress(progress).ids
    episode_ids.map { |id| new(id) }
  end
end

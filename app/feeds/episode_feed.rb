class EpisodeFeed < Feed
  def self.follows_for_progress(media, progress, limit: 3)
    episode_ids = media.episodes.for_progress(progress).limit(limit).order(number: :desc).ids
    episode_ids.map { |id| new(id) }
  end
end

class ChapterFeed < Feed
  def read_target
    ['chapter_aggr', id]
  end

  def self.follows_for_progress(media, progress, limit: 3)
    return [] unless progress
    chapter_ids = media.chapters.for_progress(progress).limit(limit).order(number: :desc).ids
    chapter_ids.map { |id| new(id) }
  end
end

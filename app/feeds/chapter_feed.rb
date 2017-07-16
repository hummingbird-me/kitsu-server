class ChapterFeed < Feed
  def self.follows_for_progress(media, progress, limit: 3)
    chapter_ids = media.chapters.for_progress(progress).limit(limit).order(number: :desc).ids
    chapter_ids.map { |id| new(id) }
  end
end

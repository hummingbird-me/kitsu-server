class ChapterFeed < Feed
  def self.follows_for_progress(media, progress)
    chapter_ids = media.chapters.for_progress(progress).ids
    chapter_ids.map { |id| new(id) }
  end
end

class MediaAiringFeed < Feed
  def read_target
    ['media_airing', id]
  end

  def write_target
    ['media_airing', id]
  end
end

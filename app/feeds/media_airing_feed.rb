class MediaAiringFeed < Feed
  def read_target
    ['media_releases', id]
  end

  def write_target
    ['media_releases', id]
  end
end

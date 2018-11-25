class ChapterFeed < Feed
  def write_target
    ['unit', "Chapter-#{id}"]
  end

  def read_target
    ['unit_aggr', "Chapter-#{id}"]
  end
end

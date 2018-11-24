class EpisodeFeed < Feed
  def write_target
    ['unit', "Episode-#{id}"]
  end

  def read_target
    ['unit_aggr', "Episode-#{id}"]
  end
end

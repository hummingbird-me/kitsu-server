class GroupFeed < Feed
  def read_target
    ['group_aggr', id]
  end
end

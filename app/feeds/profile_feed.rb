class ProfileFeed < Feed
  prepend FanoutOptional

  def write_target
    ['profile', id]
  end

  def read_target
    ['profile_aggr', id]
  end
end

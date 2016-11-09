module StreamSync
  module_function

  def follow_user_aggr
    mass_follow('user_aggr', User.pluck(:id)) do |id|
      { Feed.user_aggr(id) => Feed.user(id) }
    end
  end

  def follow_timeline
    mass_follow('timeline', User.pluck(:id)) do |id|
      { Feed.timeline(id) => Feed.user(id) }
    end
  end

  def follow_global
    mass_follow('global', User.pluck(:id)) do |id|
      { Feed.global => Feed.user(id) }
    end
  end

  def follow_media_aggr(type)
    mass_follow("media_aggr<#{type.name}>", type.pluck(:id)) do |id|
      { Feed.media_aggr(type, id) => Feed.media(type, id) }
    end
  end

  def follows
    follows = Follow.pluck(:follower_id, :followed_id)
    mass_follow('Follows', follows) do |follower_id, followed_id|
      { Feed.timeline(follower_id) => Feed.user(followed_id) }
    end
  end

  private

  def mass_follow(name, list, &map_block)
    puts "#{name}:"
    print " => generating"
    follows = list.map do |*args|
      print '.' if rand(1..100) > 98
      map_block.call(*args)
    end
    print "\n"
    print ' => uploading'
    follows.in_groups_of(800, false).each do |group|
      print '.'
      sleep 0.1
      Feed.follow_many(group, scrollback: 0)
    end
    print "\n"
  end
end

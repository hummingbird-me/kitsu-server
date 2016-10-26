class StreamSync
  class << self
    def follow_user_aggr
      mass_follow('user_aggr', User.pluck(:id)) do |id|
        { Feed.user_aggr(id) => Feed.user(id) }
      end
    end

    def follow_media_aggr(type)
      mass_follow("media_aggr:#{type.name}", type.pluck(:id)) do |id|
        { Feed.media_aggr(type, id) => Feed.media(type, id) }
      end
    end

    def sync_follows
      follows = Follow.pluck(:follower_id, :followed_id)
      mass_follow('Follows', follows) do |follower_id, followed_id|
        { Feed.timeline(follower_id) => Feed.user(followed_id) }
      end
    end

    def dump_posts
     User.pluck(:id).map do |user_id|
       posts = Post.where(user_id: user_id)
       next if posts.blank?
       {
         instruction: 'add_activities',
         feedId: Feed.user(user_id).stream_id,
         data: posts.find_each.map(&:complete_stream_activity)
       }
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
end

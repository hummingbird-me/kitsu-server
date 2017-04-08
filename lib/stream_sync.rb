module StreamSync
  module_function

  def follow_user_aggr
    mass_follow('user_aggr', User.pluck(:id)) do |id|
      { Feed.user_aggr(id) => Feed.user(id) }
    end
  end

  def follow_group_aggr
    mass_follow('group_aggr', Group.pluck(:id)) do |id|
      { Feed.group_aggr(id) => Feed.group(id) }
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

  def media_genres
    genres_for Anime
    genres_for Manga
    genres_for Drama
  end

  def user_ratings
    print ' => uploading'
    User.ids.in_groups_of(990, false).each do |user_ids|
      print '.'

      entries = LibraryEntry.where(user_id: user_ids)
                            .select(:media_type, :media_id, :status, :user_id,
                              :rating)
                            .group_by(&:user_id)

      data = user_ids.map { |user_id|
        ["User:#{user_id}", {
          library: entries[user_id].map { |entry|
            stream_id = "#{entry.media_type}:#{entry.media_id}"
            [stream_id, {
              status: entry.status,
              rating: entry.rating
            }]
          }.to_h
        }]
      }.to_h

      custom_endpoint_client.upload_meta(data)
      print '^'
    end
    print "\n"
  end

  def genres_for(klass)
    puts "#{klass.name}:"
    print ' => uploading'
    klass.includes(:genres).in_groups_of(990, false).each do |items|
      data = items.map { |media|
        print '.' if rand(1..100) > 98
        [media.stream_id, { genres: media.genres.map(&:slug) }]
      }.to_h
      custom_endpoint_client.upload_meta(data)
      print '^'
    end
    print "\n"
  end

  def mass_follow(name, list, &map_block)
    puts "#{name}:"
    print ' => generating'
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

  def custom_endpoint_client
    @client ||= Stream::CustomEndpointClient.new
  end
end

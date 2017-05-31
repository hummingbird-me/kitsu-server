module StreamSync
  module_function

  def follow_user_aggr
    ids = User.pluck(:id)
    mass_follow('user_aggr', ids) do |id|
      { Feed.user_aggr(id) => Feed.user_posts(id) }
    end

    mass_follow('user_aggr', ids) do |id|
      { Feed.user_aggr(id) => Feed.user_media(id) }
    end

    mass_follow('user_posts_aggr', ids) do |id|
      { Feed.user_posts_aggr(id) => Feed.user_posts(id) }
    end

    mass_follow('user_media_aggr', ids) do |id|
      { Feed.user_media_aggr(id) => Feed.user_media(id) }
    end
  end

  def follow_group_aggr
    mass_follow('group_aggr', Group.pluck(:id)) do |id|
      { Feed.group_aggr(id) => Feed.group(id) }
    end
  end

  def follow_timeline
    ids = User.pluck(:id)

    mass_follow('timeline', ids) do |id|
      { Feed.timeline(id) => Feed.user_posts(id) }
    end

    mass_follow('timeline', ids) do |id|
      { Feed.timeline(id) => Feed.user_media(id) }
    end

    mass_follow('timeline_posts', ids) do |id|
      { Feed.timeline_posts(id) => Feed.user_posts(id) }
    end

    mass_follow('timeline_media', ids) do |id|
      { Feed.timeline_media(id) => Feed.user_media(id) }
    end
  end

  def follow_global
    ids = User.pluck(:id)

    mass_follow('global', ids) do |id|
      { Feed.global => Feed.user_posts(id) }
    end

    mass_follow('global', ids) do |id|
      { Feed.global => Feed.user_media(id) }
    end

    mass_follow('global_posts', ids) do |id|
      { Feed.global_posts => Feed.user_posts(id) }
    end

    mass_follow('global_media', ids) do |id|
      { Feed.global_media => Feed.user_media(id) }
    end
  end

  def follow_site_announcements
    ids = User.pluck(:id)

    mass_follow('announcements', ids, scrollback: 0) do |id|
      global = SiteAnnouncementsGlobalFeed.new.stream_id
      { target: global, source: SiteAnnouncementsFeed.new(id).stream_id }
    end
  end

  def follow_media_aggr(type)
    ids = type.pluck(:id)

    mass_follow("media_aggr<#{type.name}>", ids) do |id|
      { Feed.media_aggr(type, id) => Feed.media_posts(type, id) }
    end

    mass_follow("media_aggr<#{type.name}>", ids) do |id|
      { Feed.media_aggr(type, id) => Feed.media_media(type, id) }
    end

    mass_follow("media_posts_aggr<#{type.name}>", ids) do |id|
      { Feed.media_posts_aggr(type, id) => Feed.media_posts(type, id) }
    end

    mass_follow("media_media_aggr<#{type.name}>", ids) do |id|
      { Feed.media_media_aggr(type, id) => Feed.media_media(type, id) }
    end
  end

  def follows
    follows = Follow.pluck(:follower_id, :followed_id)

    mass_follow('Follows', follows) do |follower_id, followed_id|
      { Feed.timeline(follower_id) => Feed.user_posts(followed_id) }
    end

    mass_follow('Follows', follows) do |follower_id, followed_id|
      { Feed.timeline(follower_id) => Feed.user_media(followed_id) }
    end

    mass_follow('Post Follows', follows) do |follower_id, followed_id|
      { Feed.timeline_posts(follower_id) => Feed.user_posts(followed_id) }
    end

    mass_follow('Media Follows', follows) do |follower_id, followed_id|
      { Feed.timeline_media(follower_id) => Feed.user_media(followed_id) }
    end
  end

  def media_genres
    genres_for Anime
    genres_for Manga
    genres_for Drama
  end

  def media_categories
    categories_for Anime
    categories_for Manga
    categories_for Drama
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

  def categories_for(klass)
    puts "#{klass.name}:"
    print ' => uploading'
    klass.includes(:categories).in_groups_of(990, false).each do |items|
      data = items.map { |media|
        print '.' if rand(1..100) > 98
        [media.stream_id, { categories: media.categories.map(&:id) }]
      }.to_h
      custom_endpoint_client.upload_meta(data)
      print '^'
    end
    print "\n"
  end

  def mass_follow(name, list, scrollback: 300)
    puts "#{name}:"
    print ' => generating'
    follows = list.map do |*args|
      print '.' if rand(1..100) > 98
      yield(*args)
    end
    print "\n"
    print ' => uploading'
    follows.in_groups_of(800, false).each do |group|
      print '.'
      sleep 0.1
      Feed::StreamFeed.follow_many(group, scrollback)
    end
    print "\n"
  end

  def custom_endpoint_client
    @client ||= Stream::CustomEndpointClient.new
  end
end

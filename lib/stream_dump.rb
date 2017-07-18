Dir['lib/stream_dump/*'].each do |file|
  require_dependency(File.expand_path(file))
end

module StreamDump
  module_function

  def split_profiles(scope = User)
    results = each_user(scope) do |user_id|
      # Split the feed
      split_feed(ProfileFeed.new(user_id))
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_media
    results = each_media do |media_type, media_id|
      split_feed(MediaFeed.new(media_type, media_id))
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_timelines(scope = User)
    results = each_user(scope) do |user_id|
      split_feed(TimelineFeed.new(user_id), limit: 500)
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def private_library_feed(scope = User)
    each_user(scope) do |user_id|
      entries = LibraryEntry.where(user_id: user_id)
                            .pluck(:id, :status, :rating, :progress,
                              :updated_at, :media_type, :media_id)
      entries = entries.map do |(id, status, rating, progress, updated_at, media_type, media_id)|
        [
          {
            # STATUS
            verb: 'updated',
            foreign_id: "LibraryEntry:#{id}:updated-#{status}",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            status: status,
            time: updated_at
          },
          {
            # RATING
            verb: 'rated',
            foreign_id: "LibraryEntry:#{id}:rated",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            rating: rating,
            time: updated_at
          },
          {
            # PROGRESS
            verb: 'progressed',
            foreign_id: "LibraryEntry:#{id}:progressed-#{progress}",
            object: "LibraryEntry:#{id}",
            actor: "User:#{user_id}",
            media: "#{media_type}:#{media_id}",
            progress: progress,
            time: updated_at
          }
        ]
      end
      entries = entries.flat_map { |x| x }

      {
        instruction: 'add_activities',
        feedId: "private_library:#{user_id}",
        data: entries
      }
    end
  end

  def group_timeline_demigration(scope = User)
    results = each_user(scope) do |user_id|
      group_ids = GroupMember.where(user_id: user_id).pluck(:group_id)
      group_feeds = group_ids.map { |id| "group:#{id}" }

      [
        {
          instruction: 'unfollow',
          feedId: "group_timeline:#{user_id}",
          data: group_feeds
        },
        {
          instruction: 'follow',
          feedId: "timeline:#{user_id}",
          data: group_feeds
        }
      ]
    end
    # Flatten the results lazily
    results.flat_map { |x| x }
  end

  def split_feed(feed, limit: nil)
    activities = feed.activities_for(type: :flat).unenriched.to_enum

    posts_activities = []
    media_activities = []
    posts_feed = feed.stream_feed_for(filter: :posts).stream_id
    media_feed = feed.stream_feed_for(filter: :media).stream_id

    activities.each do |act|
      if Feed::MEDIA_VERBS.include?(act.verb)
        media_activities << act
      elsif Feed::POST_VERBS.include?(act.verb)
        posts_activities << act
      end
      break if limit && posts_activities.size > limit && media_activities.size > limit
    end

    [
      {
        instruction: 'add_activities',
        feedId: media_feed,
        data: media_activities.map(&:as_json)
      },
      {
        instruction: 'add_activities',
        feedId: posts_feed,
        data: posts_activities.map(&:as_json)
      }
    ]
  end

  def posts(scope = User)
    each_user(scope) do |user_id|
      posts = StreamDump::Post.for_user(user_id).includes(:user)
      next if posts.blank?
      data = posts.find_each.map(&:complete_stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.user(user_id).stream_id,
        data: data
      }
    end
  end

  def group_posts(scope = Group)
    each_group(scope) do |group_id|
      posts = StreamDump::Post.for_group(group_id).includes(:user)
      next if posts.blank?
      data = posts.find_each.map(&:complete_stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: "group_aggr:#{group_id}",
        data: data
      }
    end
  end

  def stories(scope = User)
    each_user(scope) do |user_id|
      substories = StreamDump::Substory.for_user(user_id).media_update
                                       .with_library_entry
      next if substories.blank?
      data = substories.find_each.map(&:stream_activity).compact
      next if data.blank?
      {
        instruction: 'add_activities',
        feedId: Feed.user(user_id).stream_id,
        data: data
      }
    end
  end

  def follows(scope = User)
    results = each_user(scope) do |user_id|
      follows = Follow.where(follower: user_id).pluck(:followed_id)
      ['media', 'posts', nil].map do |filter|
        source_group = ['timeline', filter].compact.join('_')
        source_feed = "#{source_group}:#{user_id}"
        profile_group = ['user', filter].compact.join('_')
        self_feed = "#{profile_group}:#{user_id}"
        {
          instruction: 'follow',
          feedId: source_feed,
          data: follows.map { |uid| "#{profile_group}:#{uid}" } + [self_feed]
        }
      end
    end
    flatten(results)
  end

  def split_auto_follows(scope = User)
    results = each_user(scope) do |user_id|
      ['media', 'posts', nil].map do |filter|
        source_group = ['user', filter, 'aggr'].compact.join('_')
        source_feed = "#{source_group}:#{user_id}"
        target_group = ['user', filter].compact.join('_')
        target_feed = "#{target_group}:#{user_id}"
        {
          instruction: 'follow',
          feedId: source_feed,
          data: [target_feed]
        }
      end
    end
    flatten(results)
  end

  def unit_posts
    posts = StreamDump::Post.where.not(spoiled_unit_id: nil)
                            .order(:spoiled_unit_type, :spoiled_unit_id)
    count = posts.count(:all)
    bar = progress_bar('Posts', count)
    chunks = posts.find_each.chunk { |post| [post.spoiled_unit_type, post.spoiled_unit_id] }
    chunks.map do |(unit_type, unit_id), unit_posts|
      bar.progress += unit_posts.length
      data = unit_posts.map(&:complete_stream_activity).compact
      {
        instruction: 'add_activities',
        feedId: "#{unit_type.underscore}:#{unit_id}",
        data: data
      }
    end
  end

  def unit_auto_follows
    episodes = each_id(Episode, 'Episode') do |episode_id|
      {
        instruction: 'follow',
        feedId: "episode_aggr:#{episode_id}",
        data: ["episode:#{episode_id}"],
        activity_copy_limit: 20
      }
    end
    chapters = each_id(Chapter, 'Chapter') do |chapter_id|
      {
        instruction: 'follow',
        feedId: "chapter_aggr:#{chapter_id}",
        data: ["chapter:#{chapter_id}"],
        activity_copy_limit: 20
      }
    end
    flatten([chapters, episodes].lazy)
  end

  def library_progress_follows(scope = User)
    anime_global = InterestGlobalFeed.new('Anime').stream_id
    manga_global = InterestGlobalFeed.new('Manga').stream_id

    results = each_user(scope) do |user_id|
      [
        {
          instruction: 'follow',
          feedId: AnimeTimelineFeed.new(user_id).stream_id,
          data: anime_follows_for(user_id) + [anime_global]
        },
        {
          instruction: 'follow',
          feedId: MangaTimelineFeed.new(user_id).stream_id,
          data: manga_follows_for(user_id) + [manga_global]
        }
      ]
    end
    flatten(results)
  end

  def anime_follows_for(user_id)
    anime_entries = LibraryEntry.where(user_id: user_id).by_kind(:anime)
    anime_ids = anime_entries.pluck(:anime_id)
    # Get the episodes for the progress, and add a row_number by reverse order of episode number.
    # This allows us to filter based on the "recency" of episodes
    episode_ids = anime_entries.select(<<-SELECTS.squish).joins(<<-JOINS.squish)
      episodes.id,
      row_number() OVER (
        PARTITION BY episodes.media_type, episodes.media_id
        ORDER BY episodes.number DESC
      )
    SELECTS
      JOIN episodes ON (episodes.number <= progress OR reconsume_count > 1)
                    AND episodes.media_id = library_entries.anime_id
                    AND episodes.media_type = 'Anime'
    JOINS
    # Grab the Episode IDs for the last 3 episodes the user has seen, for each show
    episode_ids = Episode.from(episode_ids).where('row_number <= 3').pluck('subquery.id')
    # Convert them to Stream IDs
    episode_ids.map { |id| "episode:#{id}" } + anime_ids.map { |id| "anime:#{id}" }
  end

  def manga_follows_for(user_id)
    manga_entries = LibraryEntry.where(user_id: user_id).by_kind(:manga)
    manga_ids = manga_entries.pluck(:manga_id)
    # Get the chapters for the progress, and add a row_number by reverse order of chapter number.
    # As above, this allows us to filter to just the last few chapters.
    chapter_ids = manga_entries.select(<<-SELECTS.squish).joins(<<-JOINS.squish)
      chapters.id,
      row_number() OVER (PARTITION BY chapters.manga_id ORDER BY chapters.number DESC)
    SELECTS
      JOIN chapters ON (chapters.number <= progress OR reconsume_count > 1)
                    AND chapters.manga_id = library_entries.manga_id
    JOINS
    # Grab the Chapter IDS for the last 3 chapters the user has seen, for each show
    chapter_ids = Chapter.from(chapter_ids).where('row_number <= 3').pluck('subquery.id')
    # Convert them to Stream IDs
    chapter_ids.map { |id| "chapter:#{id}" } + manga_ids.map { |id| "manga:#{id}" }
  end

  def flatten(enumerator)
    enumerator.flat_map { |x| x }
  end

  def group_memberships(scope = User)
    each_user(scope) do |user_id|
      groups = GroupMember.where(user: user_id).pluck(:group_id)
      {
        instruction: 'follow',
        feedId: Feed.timeline(user_id).stream_id,
        data: groups.map { |gid| Feed.group(gid).stream_id }
      }
    end
  end

  def auto_follows
    users = each_user do |user_id|
      {
        instruction: 'follow',
        feedId: Feed.user_aggr(user_id).stream_id,
        data: [Feed.user(user_id).stream_id]
      }
    end
    media = each_media do |type, id|
      {
        instruction: 'follow',
        feedId: Feed.media_aggr(type, id).stream_id,
        data: [Feed.media(type, id).stream_id]
      }
    end
    [users, media].lazy.flat_map { |list| list }
  end

  def group_auto_follows
    each_group do |group_id|
      {
        instruction: 'follow',
        feedId: Feed.group_aggr(group_id).stream_id,
        data: [Feed.group(group_id).stream_id]
      }
    end
  end

  def each_user(scope = User, &block)
    each_id(scope, 'User', &block)
  end

  def each_group(scope = Group, &block)
    each_id(scope, 'Group', &block)
  end

  def each_anime(scope = Anime, &block)
    each_id(scope, 'Anime', &block)
  end

  def each_manga(scope = Manga, &block)
    each_id(scope, 'Manga', &block)
  end

  def each_drama(scope = Drama, &block)
    each_id(scope, 'Drama', &block)
  end

  def each_media
    [
      each_anime { |id| yield 'Anime', id },
      each_manga { |id| yield 'Manga', id },
      each_drama { |id| yield 'Drama', id }
    ].lazy.flat_map { |list| list }
  end

  def each_id(scope, title, &block)
    items = scope.pluck(:id).each.lazy
    bar = progress_bar(title, scope.count(:all))
    # HACK: Normally we'd use #each because we don't want to modify the values,
    # but we need to stay lazy, and Enumerator::Lazy#each will collapse the
    # laziness.
    items.map(&block).map { |i|
      bar.increment
      i
    }.reject(&:nil?)
  end

  def progress_bar(title, count)
    ProgressBar.create(
      title: title,
      total: count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
  end
end

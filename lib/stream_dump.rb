Dir['lib/stream_dump/*'].each do |file|
  require_dependency(File.expand_path(file))
end

module StreamDump
  module_function

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
        feedId: Feed.group(group_id).stream_id,
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
    each_user(scope) do |user_id|
      follows = Follow.where(follower: user_id).pluck(:followed_id)
      follow_self = [Feed.user(user_id).stream_id]
      {
        instruction: 'follow',
        feedId: Feed.timeline(user_id).stream_id,
        data: follows.map { |uid| Feed.user(uid).stream_id } + follow_self
      }
    end
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

  def each_media(&block)
    [
      each_anime { |id| block.('Anime', id) },
      each_manga { |id| block.('Manga', id) },
      each_drama { |id| block.('Drama', id) }
    ].lazy.flat_map { |list| list }
  end

  def each_id(scope, title, &block)
    items = scope.pluck(:id).each.lazy
    bar = progress_bar(title, scope.count(:all))
    items.map(&block).map { |i| bar.increment; i }.reject(&:nil?)
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

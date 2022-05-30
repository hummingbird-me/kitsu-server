module StreamLog
  module_function

  def follow(source, target)
    return false unless ENV['STREAMLOG_REDIS_URL']
    return unless log_follow?(source, target)
    source = rewrite_feed(*source)
    target = rewrite_feed(*target)
    return unless source && target
    follow = follow_key(source, target)
    redis_pool.with do |r|
      r.srem('unfollow', follow)
    end
  end

  def follow_many(follows, _backlog)
    return false unless ENV['STREAMLOG_REDIS_URL']
    follow_keys = follows.map do |follow|
      source = follow[:source].split(':')
      target = follow[:target].split(':')
      next unless log_follow?(source, target)
      source = rewrite_feed(*source)
      target = rewrite_feed(*target)
      next unless source && target
      follow_key(source, target)
    end
    redis_pool.with do |r|
      r.srem('unfollow', follow_keys) if follow_keys
    end
  end

  def log_follow?(source, target)
    return false if %w[episode chapter media].include?(target[0]) && source[0] == 'timeline'
    return false if %w[interest_timeline].include?(source[0])
    true
  end

  # Rewrites feeds to aim at their renamed equivalents
  def rewrite_feed(group, id)
    case group
    when 'user' then ['profile', id]
    when 'user_aggr' then ['profile_aggr', id]
    when 'media_airing' then ['media_releases', id]
    when 'episode' then ['unit', "Episode-#{id}"]
    when 'episode_aggr' then ['unit_aggr', "Episode-#{id}"]
    when 'chapter' then ['unit', "Chapter-#{id}"]
    when 'chapter_aggr' then ['unit_aggr', "Chapter-#{id}"]
    when 'post_comments_aggr', 'private_library' then nil
    else [group, id]
    end
  end

  def follow_key(source, target)
    source = source.join(':')
    target = target.join(':')
    "#{source}->#{target}"
  end

  def redis_pool
    @redis_pool ||= ConnectionPool.new(size: ENV.fetch('RAILS_MAX_THREADS', 5)) do
      Redis.new(url: ENV.fetch('STREAMLOG_REDIS_URL', nil))
    end
  end
end

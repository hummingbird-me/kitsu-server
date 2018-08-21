module StreamLog
  module_function

  def unfollow(source, target)
    return unless enabled?
    return unless log_follow?(source, target)
    follow = follow_key(source, target)
    client.feed(*source).unfollow(target)
    redis_pool.with do |r|
      r.sadd('unfollow', follow)
    end
  end

  def follow(source, target)
    return unless enabled?
    return unless log_follow?(source, target)
    follow = follow_key(source, target)
    client.feed(*source).follow(target)
    redis_pool.with do |r|
      r.srem('unfollow', follow)
    end
  end

  def add_activity(feed, activity)
    return unless enabled?
    target = rewrite_feed(*feed)
    client.feed(*target).add_activity(activity)
  end

  def remove_activity(feed, id, foreign_id: false)
    return unless enabled?
    target = rewrite_feed(*feed).join(':')
    key = "#{target}/#{id}@#{foreign_id ? 'K' : 'S'}"
    redis_pool.with do |r|
      r.sadd('remove_activity', key)
    end
    client.feed(*feed).remove_activity(id, foreign_id)
  end

  def log_follow?(source, target)
    return false if %w[episode chapter media].include?(target[0]) && source[0] == 'timeline'
    return false if %w[interest_timeline].include?(source[0])
  end

  # Rewrites feeds to aim at their renamed equivalents
  def rewrite_feed(group, id)
    case group
    when 'user' then ['profile', id]
    when 'user_aggr' then ['profile_aggr', id]
    when 'media_airing' then ['media_releases', id]
    else [group, id]
    end
  end

  def follow_key(source, target)
    source = rewrite_feed(*source).join(':')
    target = rewrite_feed(*target).join(':')
    "#{source}->#{target}"
  end

  def enabled?
    Flipper[:stream_log].enabled?(User.current)
  end

  def redis_pool
    @redis_pool ||= ConnectionPool.new(size: ENV['RAILS_MAX_THREADS'] || 5) do
      Redis.new(url: ENV['STREAMLOG_REDIS_URL'])
    end
  end

  def client
    @client ||= Stream::Client.new(
      ENV['STREAMLOG_API_KEY'],
      ENV['STREAMLOG_API_SECRET'],
      ENV['STREAMLOG_APP_ID'],
      location: 'us-east'
    )
  end
end

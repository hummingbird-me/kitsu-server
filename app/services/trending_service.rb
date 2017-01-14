class TrendingService
  EPOCH = Date.new(2030, 1, 1).to_time.to_i
  ITEM_LIMIT = 200
  NETWORK_LIMIT = 20
  TRIM_PROBABILITY = 0.1

  attr_reader :namespace, :half_life

  def initialize(namespace, half_life: 7.days.to_i, user: nil)
    @namespace = namespace
    @half_life = half_life
    @user = user
  end

  def vote(id, weight = 1.0)
    $redis.with do |conn|
      key = trending_key
      update_score(key, change, id)
      trim(key, limit: ITEM_LIMIT) if rand < TRIM_PROBABILITY
    end
  end

  def fanout_vote
    followers.each do |uid|
      key = trending_key(uid)
      update_score(key)
      trim(key, limit: NETWORK_LIMIT) if rand < TRIM_PROBABILITY
    end
  end

  def get(limit = 5)
    results = $redis.with do |conn|
      conn.zrevrange(key, 0, limit - 1).map(&:to_i)
    end
    results = enrich(results) if enrichable?
    results
  end

  def trim(key, limit: 100)
    $redis.with do |conn|
      conn.zremrangebyrank(key, 0, -limit)
    end
  end

  private

  def trending_key(user = nil)
    user = user.id if user.respond_to?(:id)
    namespace = namespace.table_name if enrichable?
    key = "trending:#{namespace}"
    key += ":user:#{user}" if user
    key
  end

  def update_score(key, weight = 1.0, id)
    $redis.with do |conn|
      conn.zincrby(key, change_for(weight), id)
    end
  end

  def change_for(weight)
    weight * (2.0**(Time.now.to_i - EPOCH))
  end

  def followers
    user.followers.pluck(:follower_id)
  end

  def enrich(list)
    instances = namespace.where(id: list).index_by(&:id)
    ids.collect { |id| instances[id] }
  end

  def enrichable?
    namespace.respond_to? :table_name
  end
end

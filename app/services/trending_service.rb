class TrendingService
  EPOCH = Date.new(2030, 1, 1).to_time.to_i
  ITEM_LIMIT = 200
  NETWORK_LIMIT = 20
  TRIM_PROBABILITY = 0.1

  attr_reader :namespace, :half_life, :user

  def initialize(namespace, half_life: 7.days.to_i, user: nil)
    @namespace = namespace
    @half_life = half_life
    @user = user
  end

  def vote(id, weight = 1.0)
    key = trending_key
    update_score(key, id, change_for(weight))
    trim(key, limit: ITEM_LIMIT) if rand < TRIM_PROBABILITY
    if user
      TrendingFanoutWorker.perform_async(namespace, half_life, user&.id, id,
        weight)
    end
  end

  def fanout_vote(id, weight = 1.0)
    followers.each do |uid|
      key = trending_key(uid)
      update_score(key, id, change_for(weight))
      trim(key, limit: NETWORK_LIMIT) if rand < TRIM_PROBABILITY
    end
  end

  def get(limit = 5)
    key = trending_key(user_id)
    results_for(key, limit)
    results
  end

  def get_network(limit = 5)
    key = trending_key(user_id)
    results_for(key, limit)
  end

  def trim(key, limit: 100)
    $redis.with do |conn|
      conn.zremrangebyrank(key, 0, -limit)
    end
  end

  private

  def results_for(key, limit = 5, offset = 0)
    start = offset
    stop = offset + limit - 1
    results = $redis.with do |conn|
      conn.zrevrange(key, start, stop)
    end
    results = enrich(results) if enrichable?
    results
  end

  def trending_key(user = nil)
    ns = namespace
    ns = ns.table_name if enrichable?
    key = "trending:#{ns}"
    key += ":user:#{user_id}" if user
    key
  end

  def update_score(key, id, weight = 1.0)
    $redis.with do |conn|
      conn.zincrby(key, change_for(weight), id)
    end
  end

  def change_for(weight)
    weight * (2.0**(Time.now.to_i - EPOCH))
  end

  def followers
    Follow.where(followed_id: user_id).pluck(:follower_id)
  end

  def enrich(ids)
    instances = namespace.where(id: ids).index_by(&:id)
    ids.collect { |id| instances[id] }
  end

  def enrichable?
    namespace.respond_to? :table_name
  end

  def user_id
    user.respond_to?(:id) ? user.id : user
  end
end

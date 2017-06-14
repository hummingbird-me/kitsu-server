class TrendingService
  EPOCH = Date.new(2030, 1, 1).to_time.to_i
  ITEM_LIMIT = 200
  NETWORK_LIMIT = 20
  CATEGORY_LIMIT = 20
  TRIM_PROBABILITY = 0.1

  attr_reader :namespace, :half_life, :user, :token

  def initialize(namespace, half_life: 7.days.to_i, user: nil, token: nil)
    @namespace = namespace
    @half_life = half_life
    @token = token
    @user = user || token&.resource_owner
  end

  def vote(id, weight = 1.0)
    key = trending_key
    update_score(key, id, weight)
    trim(key, limit: ITEM_LIMIT) if rand < TRIM_PROBABILITY
    if user
      TrendingFanoutWorker.perform_async(namespace, half_life, user&.id, id,
        weight)
    end
  end

  def fanout_vote(id, weight = 1.0)
    followers.each do |uid|
      key = trending_key(uid)
      update_score(key, id, weight)
      trim(key, limit: NETWORK_LIMIT) if rand < TRIM_PROBABILITY
    end

    handle_trending_categories(id, weight)
  end

  def get(limit = 5)
    results_for(trending_key, limit)
  end

  def get_network(limit = 5)
    key = trending_key(user_id)
    results_for(key, limit)
  end

  def get_category(id, limit = 5)
    key = trending_category_key(id)
    results_for(key, limit)
  end

  def trim(key, limit: 100)
    $redis.with do |conn|
      conn.zremrangebyrank(key, 0, -limit)
    end
  end

  private

  def results_for(key, limit = 5, offset = 0)
    results = []
    loop.with_index do |_, index|
      break if index > 5
      page = raw_results_for(key, limit, offset)
      results += enrich(page) if enrichable?
      break if results.count > limit
      offset += limit
    end
    results[0...limit]
  end

  def raw_results_for(key, limit = 5, offset = 0)
    stop = offset + limit - 1
    $redis.with do |conn|
      conn.zrevrange(key, offset, stop)
    end
  end

  def trending_key(uid = nil)
    ns = namespace
    ns = ns.table_name if enrichable?
    key = "trending:#{ns}"
    key += ":user:#{uid}" if uid
    key
  end

  def trending_category_key(category_id)
    ns = namespace
    ns = ns.table_name if enrichable?
    key = "trending:#{ns}"
    key += ":category:#{category_id}"
    key
  end

  def handle_trending_categories(id, weight = 1.0)
    return unless %w[Anime Manga Drama].include?(namespace.name)
    categories = namespace.includes(:categories).find_by(id: id).categories
    categories.each do |category|
      key = trending_category_key(category.id)
      update_score(key, id, weight)
      trim(key, limit: CATEGORY_LIMIT) if rand < TRIM_PROBABILITY
    end
  end

  def update_score(key, id, weight = 1.0)
    $redis.with do |conn|
      conn.zincrby(key, change_for(weight), id)
    end
  end

  def change_for(weight)
    weight * (2.0**((Time.now.to_i - EPOCH).to_f / half_life))
  end

  def followers
    Follow.where(followed_id: user_id).pluck(:follower_id)
  end

  def enrich(ids)
    ids = ids.map(&:to_i)
    scope = Pundit.policy_scope!(token, namespace)
    instances = scope.where(id: ids).index_by(&:id)
    ids.collect { |id| instances[id] }.compact
  end

  def enrichable?
    namespace.respond_to? :table_name
  end

  def user_id
    user.respond_to?(:id) ? user.id : user
  end
end

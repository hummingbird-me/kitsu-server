class TrendingService
  EPOCH = Date.new(2030, 1, 1).to_time.to_i

  attr_reader :namespace, :half_life, :limit

  def initialize(namespace, half_life: 7.days.to_i, limit: 200)
    @namespace = namespace
    @half_life = half_life
    @limit = limit
  end

  def vote(id, weight = 1.0)
    $redis.with do |conn|
      conn.zincrby(key, change_for(weight))
    end
    trim! if rand * 20 < 1
  end

  def get(limit = 5)
    results = $redis.with do |conn|
      conn.zrevrange(key, 0, limit - 1).map(&:to_i)
    end
    results = enrich(results) if enrichable?
    results
  end

  def trim!(key = nil)
    key ||= trending_key
    $redis.with do |conn|
      conn.zremrangebyrank(key, 0, -limit)
    end
  end

  private

  def trending_key
    namespace = namespace.table_name if enrichable?
    "trending:#{namespace}"
  end

  def change_for(weight)
    weight * (2.0**(Time.now.to_i - EPOCH))
  end

  def enrich(list)
    instances = namespace.where(id: list).index_by(&:id)
    ids.collect { |id| instances[id] }
  end

  def enrichable?
    namespace.respond_to? :table_name
  end
end

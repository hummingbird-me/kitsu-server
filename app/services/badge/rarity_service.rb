class Badge
  class RarityService
    def initialize(badge)
      @badge = badge
    end

    def increment
      $redis.with { |conn| conn.incr(key) }
    end

    def count
      @count ||= $redis.with { |conn| conn.get(key) }.to_i
    end

    def percent
      @percent ||= count.to_f / User.count
    end

    def rarity
      case percent
      when 0...2 then :epic
      when 0...20 then :rare
      when 0...50 then :uncommon
      else :common
      end
    end

    private

    def key
      "RarityService:Global:#{badge.id}"
    end
  end
end

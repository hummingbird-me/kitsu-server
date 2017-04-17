class Stat
  class AnimeAmountConsumed < Stat
    include Stat::AmountConsumed

    # recalculate
    def media_column
      :anime
    end

    def media_length
      'anime.episode_length'
    end

    # increment & decrement
    def self.media_type
      'Anime'
    end
  end
end

class Stat < ApplicationRecord
  class AnimeFavoriteYear < Stat
    include Stat::FavoriteYear

    # recalculate
    def media_column
      :anime
    end

    def media_start_date
      'anime.start_date'
    end

    # increment & decrement
    def self.media_type
      'Anime'
    end
  end
end

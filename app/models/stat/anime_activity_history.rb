class Stat < ApplicationRecord
  class AnimeActivityHistory < Stat
    include Stat::ActivityHistory

    # recalculate
    def media_column
      :anime
    end

    # increment & decrement
    def self.media_type
      'Anime'
    end
  end
end

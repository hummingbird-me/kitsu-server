class Stat < ApplicationRecord
  class MangaFavoriteYear < Stat
    include Stat::FavoriteYear

    # recalculate
    def media_column
      :manga
    end

    def media_start_date
      'manga.start_date'
    end

    # increment & decrement
    def self.media_type
      'Manga'
    end
  end
end

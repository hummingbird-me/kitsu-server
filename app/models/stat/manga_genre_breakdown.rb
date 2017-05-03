class Stat < ApplicationRecord
  class MangaGenreBreakdown < Stat
    include Stat::GenreBreakdown

    # for recalculate!
    def media_column
      :manga
    end

    # for class methods
    def self.media_type
      'Manga'
    end
  end
end

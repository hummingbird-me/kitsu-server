class Stat < ApplicationRecord
  class MangaActivityHistory < Stat
    include Stat::ActivityHistory

    # recalculate
    def media_column
      :manga
    end

    # increment & decrement
    def self.media_type
      'Manga'
    end
  end
end

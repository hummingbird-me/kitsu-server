class Stat
  class MangaAmountConsumed < Stat
    include Stat::AmountConsumed

    # recalculate
    def media_column
      :manga
    end

    def media_length
      # this will change once we have a way
      # to calculate how much time was spent reading
      # a manga.
      'manga.id'
    end

    # increment & decrement
    def self.media_type
      'Manga'
    end
  end
end

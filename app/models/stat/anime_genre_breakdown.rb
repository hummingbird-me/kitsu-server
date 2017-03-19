class Stat
  class AnimeGenreBreakdown < Stat
    # fully regenerate data
    def recalculate!
      p user.library_entries
      library_entries.each do |library_entry|
        library_entry.media.genres.each do |genre|
          increment_data(genre.slug)
        end
      end

      if new_record?
        # self.data = new_data
        # save
      else
        update_attribute(:stats_data, stats_data)
      end
    end

    # update data with + 1
    def library_entry_update(library_entry)

    end

    private

    def library_entries
      user.library_entries.where(media_type: 'Anime')
    end

    def increment_data(slug)
      unless stats_data[slug]
        self.stats_data[slug] = 0
      end

      self.stats_data[slug] += 1
    end
  end
end

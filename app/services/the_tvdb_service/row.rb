class TheTvdbService
  class Row < TheTvdbService
    attr_reader :media, :data, :tvdb_episode_id, :tvdb_series_id

    def initialize(media, data, tvdb_series_id, first_number)
      @media = media
      @data = data
      @tvdb_episode_id = data['id']
      @tvdb_series_id = tvdb_series_id
      @first_number = first_number
    end

    def update_episode
      return unless number.present?

      episode.titles = titles.merge(episode.titles)
      episode.canonical_title ||= 'en_us'
      episode.number ||= number
      episode.season_number ||= season_number
      episode.relative_number ||= relative_number
      episode.description['en'] ||= synopsis
      episode.thumbnail = thumbnail if episode.thumbnail.blank?
      episode.airdate ||= airdate
      episode.save!
      episode
    rescue StandardError => e
      Raven.capture_exception(e)
    end

    def titles
      { en_us: data['episodeName'].presence || "Episode #{episode.number}" }
    end

    def canonical_title
      'en_us'
    end

    def number
      relative_number
    end

    def season_number
      data['airedSeason']
    end

    def relative_number
      data['airedEpisodeNumber'] - @first_number + 1 if data['airedEpisodeNumber'].present?
    end

    def synopsis
      data['overview'].presence
    end

    def thumbnail
      URI("https://thetvdb.com/banners/episodes/#{tvdb_series_id}/#{tvdb_episode_id}.jpg")
    end

    def airdate
      data['firstAired']
    end

    private

    def episode
      @episode ||= Episode.where(
        media: media,
        number: number
      ).first_or_initialize
    end

    def absolute_number
      data['absoluteNumber']
    end
  end
end

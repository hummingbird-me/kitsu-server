class TheTvdbService
  class Row < TheTvdbService
    attr_reader :media, :data, :tvdb_episode_id, :tvdb_series_id

    def initialize(media, data, tvdb_series_id)
      @media = media
      @data = data
      @tvdb_episode_id = data['id']
      @tvdb_series_id = tvdb_series_id
    end

    def update_episode
      return unless number.present?

      attributes = %i[
        titles canonical_title number season_number relative_number synopsis thumbnail airdate
      ].map { |k| [k, public_send(k)] }.to_h.reject { |_, v| v.blank? }

      episode.update(attributes)
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
      return data['absoluteNumber'].presence unless data['absoluteNumber']&.zero?
      data['airedEpisodeNumber'].presence
    end

    def season_number
      data['airedSeason']
    end

    def relative_number
      data['airedEpisodeNumber']
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
  end
end

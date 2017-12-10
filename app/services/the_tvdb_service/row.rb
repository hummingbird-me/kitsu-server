class TheTvdbService
  class Row < TheTvdbService
    attr_reader :media_id, :media_type, :data, :episode_id, :tvdb_series_id

    def initialize(media_id, data, tvdb_series_id)
      @media_id = media_id
      @data = data
      @episode_id = data['id']
      @tvdb_series_id = tvdb_series_id
      @media_type = 'Anime'
    end

    def update_episode
      return unless episode_number.present?

      # All these methods will be modifying the episode object in-place
      %i[
        season_number relative_number synopsis
        thumbnail airdate titles canonical_title
      ].each { |k| public_send(k) }

      # This will create the mapping for an episode related to an imdbId.
      create_episode_mapping

      episode
    end

    def update_episode!
      update_episode.save!
    end

    def season_number
      episode.season_number ||= data['airedSeason']
    end

    def relative_number
      episode.relative_number ||= data['airedEpisodeNumber']
    end

    def synopsis
      # was returning an empty string and storing that in database.
      episode.synopsis = data['overview'].presence || nil if episode.synopsis.blank?
    end

    def thumbnail
      episode.thumbnail ||= thumbnail_path
    end

    def airdate
      episode.airdate ||= data['firstAired']
    end

    def titles
      # HACK: in the edge case where there is no episodeName returned by Tvdb
      # and our database titles has {"en_jp" => nil}, I need to make sure en_jp title
      # exists, otherwise it will cause a validation error.
      episode.titles['en_jp'] ||= episode_name
      # only set en_us if the tvdb has it.
      episode.titles['en_us'] ||= data['episodeName'] if data['episodeName'].present?
    end

    def canonical_title
      episode.canonical_title = 'en_us' if episode.titles.key?('en_us')
    end

    def episode
      @ep ||= Episode.where(
        media_id: media_id,
        media_type: media_type,
        number: episode_number
      ).first_or_initialize
    end

    def thumbnail_path
      # https://thetvdb.com/banners/episodes/80979/345630.jpg
      "https://thetvdb.com/banners/episodes/#{tvdb_series_id}/#{episode_id}.jpg"
    end

    def episode_number
      data['absoluteNumber'].presence || data['airedEpisodeNumber'].presence || false
    end

    def episode_name
      data['episodeName'].presence || "Episode #{episode.number}"
    end

    def create_episode_mapping
      response_body = get("/episodes/#{episode_id}")
      return if response_body['data']['imdbId'].blank?

      Mapping.create(
        item: episode,
        external_site: 'imdb/episodes',
        external_id: response_body['data']['imdbId']
      )
    end
  end
end

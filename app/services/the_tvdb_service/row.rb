class TheTvdbService
  class Row
    attr_reader :media_id, :media_type, :data

    def initialize(media_id, data)
      @media_id = media_id
      @data = data
      # not sure if I am going to actually need this.
      @media_type = 'Anime'
    end

    def update_episode!
      episode = Episode.first_or_initialize(
        media_id: media_id,
        media_type: media_type,
        number: data['absoluteNumber']
      )

      episode.season_number ||= data['airedSeason']
      episode.relative_number ||= data['airedEpisodeNumber']
      # was returning an empty string and not updating.
      episode.synopsis = data['overview'] if episode.synopsis.nil?
      episode.airdate ||= data['firstAired']
      episode.titles['en_us'] ||= data['episodeName']
      episode.canonical_title = 'en_us' unless episode.titles.key?('en_jp')

      episode.save! if episode.changed?
    end

    def update_mapping!
      # update the `thetvdb/series` external_id to be formatted as `series_id/season_number`
    end
  end
end

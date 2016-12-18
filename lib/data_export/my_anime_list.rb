module DataExport
  class MyAnimeList
    ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
    MINE = '?mine=1'.freeze

    include DataExport::HTTP

    attr_reader :entry, :method

    def initialize(entry, method)
      @entry = entry
      @method = method
    end

    def execute_method
      # get correct mal info
      mal_media = Mapping.lookup('myanimelist', entry.media_id)
      profile = LinkedProfile.find_by(
        user_id: entry.user_id,
        url: 'myanimelist'
      )

      media_type = entry.media_type.downcase
      mal_media_id = mal_media.external_id

      case method
      when 'delete'
        delete(
          "#{animelist}/#{mal_media_type}/#{mal_media_id}",
          profile
        )
      else
        # find the anime or manga
        get("#{media_type}/#{mal_media_id}#{MINE}", profile) do |response|
          # check if watched status exists
          if response['watched_status']
            # update
            # TODO: retry later on if we need to
            put(
              "animelist/#{media_type}/#{mal_media_id}",
              profile,
              {
                status: format_status(entry.status),
                episodes: entry.progress,
                score: format_score(entry&.rating),
                rewatch_count: entry.reconsume_count
              }
            )
          else
            # create
            # TODO: retry later on if we need to
            post(
              "animelist/#{media_type}",
              profile,
              {
                anime_id: mal_media_id,
                status: format_status(entry.status),
                episodes: entry.progress,
                score: format_score(entry&.rating)
              }
            )
          end
        end

        # if block is not executed because
        # response.code was not a 200
        # TODO: check timing
        # return nil
      end
    end

    def format_status(status)
      # change our status -> mal status
      case status
      when 'current' then 1 # watching
      when 'planned' then 6 # plan to watch
      when 'completed' then 2 # completed
      when 'on_hold' then 3 # on hold
      when 'dropped' then 4 # dropped
      end
    end

    # if you send no score in
    # ie: &score&anythingelse
    # it will not set the score
    def format_score(score)
      return nil if score.nil?

      (score * 2).floor
    end

    private

    def get(url, profile, opts = {})
      url = build_url(url)
      super(url, profile, opts)
    end

    def post(url, profile, body, opts = {})
      url = build_url(url)
      super(url, profile, body, opts)
    end

    def put(url, profile, body, opts = {})
      url = build_url(url)
      super(url, profile, body, opts)
    end

    def delete(url, profile, opts = {})
      url = build_url(url)
      super(url, profile, opts)
    end

    def build_url(path)
      "#{ATARASHII_API_HOST}#{path}"
    end
  end
end

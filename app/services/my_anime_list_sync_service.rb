class MyAnimeListSyncService
  ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
  MINE = '?mine=1'.freeze

  attr_reader :le, :method

  def initialize(le, method)
    @le = le
    @method = method
  end

  def execute_method
    # anime or manga
    media_type = le.media_type.underscore
    # convert kitsu data -> mal data
    mal_media = le.media.mappings.find_by(site: "myanimelist/#{media_type}")
    # user mal profile information
    profile = LinkedProfile.find_by(
      user_id: le.user_id,
      url: 'myanimelist'
    )
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
        # need to check watched_status OR read_status
        if media_type == 'anime'
          if response['watched_status']
            put(
              "animelist/#{media_type}/#{mal_media_id}",
              profile,
              {
                status: format_status(le.status),
                episodes: le.progress,
                score: format_score(le.rating),
                rewatch_count: le.reconsume_count
              }
            )
          else
            post(
              "animelist/#{media_type}",
              profile,
              {
                anime_id: mal_media_id,
                status: format_status(le.status),
                episodes: le.progress,
                score: format_score(le.rating)
              }
            )
          end
        else
          # manga
          if response['read_status']
            put(
              "mangalist/#{media_type}/#{mal_media_id}",
              profile,
              {
                status: format_status(le.status),
                chapters: le.progress,
                score: format_score(le.rating),
                reread_count: le.reconsume_count
              }
            )
          else
            post(
              "mangalist/#{media_type}",
              profile,
              {
                manga_id: mal_media_id,
                status: format_status(le.status),
                chapters: le.progress,
                score: format_score(le.rating)
              }
            )
          end
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
    when 'current' then 1 # watching/reading
    when 'planned' then 6 # plan to watch/plan to read
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

  def get(url, profile)
    request = Typhoeus::Request.new(
      build_url(url),
      method: :get,
      userpwd: simple_auth(profile)
    )

    request_status(request) do |response|
      yield response
    end
    request.run
  end

  def post(url, profile, body)
    request = Typhoeus::Request.new(
      build_url(url),
      method: :post,
      userpwd: simple_auth(profile),
      body: body
    )

    # TODO: @nuck is there a better way to handle this?
    request_status(request) do |response|
      # doesn't need to do anything if success
    end
    request.run
  end

  def put(url, profile, body)
    request = Typhoeus::Request.new(
      build_url(url),
      method: :put,
      userpwd: simple_auth(profile),
      body: body
    )

    # TODO: @nuck is there a better way to handle this?
    request_status(request) do |response|
      # doesn't need to do anything if success
    end
    request.run
  end

  def delete(url, profile)
    request = Typhoeus::Request.new(
      build_url(url),
      method: :delete,
      userpwd: simple_auth(profile)
    )

    # TODO: @nuck is there a better way to handle this?
    request_status(request) do |response|
      # doesn't need to do anything if success
    end
    request.run
  end

  def request_status(request)
    # will return request or nil
    request.on_complete do |response|
      if response.success?
        # this is being sent up to either
        # get/create/update/delete
        # afterwards the chosen method will send it up
        # to the parent request under my_anime_list.rb

        # delete will not have a body so need try catch
        yield response&.body
      elsif response.timed_out?
        # aw hell no
        $stderr.puts('got a time out')
      elsif response.code.zero?
        # Could not get an http response, something's wrong.
        $stderr.puts(response.return_message)
      else
        # Received a non-successful http response.
        $stderr.puts('HTTP request failed: ' + response.code.to_s)
      end
    end
  end

  def build_url(path)
    "#{ATARASHII_API_HOST}#{path}"
  end

  def simple_auth(profile)
    "#{profile.external_user_id}:#{profile.token}"
  end
end

class MyAnimeListSyncService
  ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
  MINE = '?mine=1'.freeze

  attr_reader :library_entry, :method

  def initialize(library_entry, method)
    @library_entry = library_entry
    @method = method
  end

  def execute_method
    # TODO: add errors later on if we can't find mal data
    return if mal_media.nil?

    case method
    when 'delete'
      delete("#{media_type}list/#{media_type}/#{mal_media_id}", linked_account)
    when 'create/update'
      # find the anime or manga
      # it will raise an error if it fails the http request
      response = get("#{media_type}/#{mal_media_id}#{MINE}", linked_account)

      if media_type == 'anime' && response['watched_status']
        p 'PUT anime'
        put("animelist/anime/#{mal_media_id}", linked_account,
          status: format_status(library_entry.status),
          episodes: library_entry.progress,
          score: format_score(library_entry.rating),
          rewatch_count: library_entry.reconsume_count)
      elsif media_type == 'anime'
        p 'POST anime'
        post('animelist/anime', linked_account,
          anime_id: mal_media_id,
          status: format_status(library_entry.status),
          episodes: library_entry.progress,
          score: format_score(library_entry.rating))
      elsif media_type == 'manga' && response['read_status']
        put("mangalist/manga/#{mal_media_id}", linked_account,
          status: format_status(library_entry.status),
          chapters: library_entry.progress,
          score: format_score(library_entry.rating),
          reread_count: library_entry.reconsume_count)
      else # should I use else to catch errors?
        post('mangalist/manga', linked_account,
          manga_id: mal_media_id,
          status: format_status(library_entry.status),
          chapters: library_entry.progress,
          score: format_score(library_entry.rating))
      end
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
    (score * 2).to_i if score
  end

  private

  def get(url, profile)
    res = Typhoeus::Request.new(
      build_url(url),
      method: :get,
      userpwd: simple_auth(profile)
    ).run

    # will raise an error if something is wrong
    # otherwise will return true
    check_response_status(res)

    res.response_body
  end

  def post(url, profile, body)
    res = Typhoeus::Request.new(
      build_url(url),
      method: :post,
      userpwd: simple_auth(profile),
      body: body
    ).run

    check_response_status(res)

    res.response_body
  end

  def put(url, profile, body)
    p res = Typhoeus::Request.put(
      build_url(url),
      headers: {'Content-Type'=> 'application/x-www-form-urlencoded'},
      userpwd: simple_auth(profile),
      body: body
    )

    check_response_status(res)

    res.response_body
  end

  def delete(url, profile)
    res = Typhoeus::Request.new(
      build_url(url),
      method: :delete,
      userpwd: simple_auth(profile)
    ).run

    check_response_status(res)

    res.response_body
  end

  def check_response_status(response)
    return true if response.success?

    # timed out
    raise 'Request Timed Out' if response.timed_out?
    # could not get an http response
    raise response.return_message.to_s if response.code.zero?
    # received a non-successfull http response
    raise "HTTP request failed: #{response.code}"
  end

  def media_type
    # anime or manga
    @media_type ||= library_entry.media_type.underscore
  end

  def mal_media
    # convert kitsu data -> mal data
    @mal_media ||= library_entry.media.mappings.find_by(
      external_site: "myanimelist/#{media_type}"
    )
  end

  def mal_media_id
    mal_media.external_id
  end

  def linked_account
    @profile ||= User.find(library_entry.user_id).linked_accounts.find_by(
      sync_to: true,
      type: 'LinkedAccount::MyAnimeList'
    )
  end

  def build_url(path)
    "#{ATARASHII_API_HOST}#{path}"
  end

  def simple_auth(profile)
    "#{profile.external_user_id}:#{profile.token}"
  end
end

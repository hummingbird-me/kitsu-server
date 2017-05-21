class MyAnimeListSyncService
  class TimeoutError < StandardError; end
  class MediaNotFound < StandardError; end
  class BadAuthorization < StandardError; end
  class ConnectFailed < StandardError; end
  class UnknownError < StandardError; end

  ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
  MINE = '?mine=1'.freeze

  attr_reader :library_entry, :method
  attr_accessor :library_entry_log

  def initialize(library_entry, method, library_entry_log)
    @library_entry = library_entry
    @method = method
    @library_entry_log = library_entry_log
  end

  def execute_method
    # Logs the error so the user can see what didn't sync.
    if mal_media.nil?
      library_entry_log.update(
        sync_status: :error,
        action_performed: method,
        error_message: 'Unable to convert Kitsu data to MAL data'
      )
      return
    end

    case method
    when 'delete'
      delete(
        "#{media_type}list/#{media_type}/#{mal_media_id}",
        linked_account
      )
    when 'create', 'update'
      # find the anime or manga
      # it will raise an error if it fails the http request
      response = get(
        "#{media_type}/#{mal_media_id}#{MINE}",
        linked_account
      )

      if media_type == 'anime' && response['watched_status']
        # anime already exists in their list
        put("animelist/anime/#{mal_media_id}", linked_account,
          status: format_status(library_entry.status),
          episodes: library_entry.progress,
          score: format_score(library_entry.rating),
          rewatch_count: library_entry.reconsume_count)
      elsif media_type == 'anime'
        # anime does not exist in their list
        post('animelist/anime', linked_account,
          anime_id: mal_media_id,
          status: format_status(library_entry.status),
          episodes: library_entry.progress,
          score: format_score(library_entry.rating))
      elsif media_type == 'manga' &&
            (response['id'].nil? || response['read_status'])
        # manga already exists in their list

        # HACK: this is related to what check_response_status will return due to
        # some bug, it will just return an error message, so this checks to see
        # if an id exists in the object, (every object will have an id
        # regardless of anime/manga, but as of right now it won't).  Once fixed,
        # it should be checking for read_status like anime does with
        # watched_status
        put("mangalist/manga/#{mal_media_id}", linked_account,
          status: format_status(library_entry.status),
          chapters: library_entry.progress,
          score: format_score(library_entry.rating),
          reread_count: library_entry.reconsume_count)
      else
        # manga does not exist in their list
        post('mangalist/manga', linked_account,
          manga_id: mal_media_id,
          status: format_status(library_entry.status),
          chapters: library_entry.progress,
          score: format_score(library_entry.rating))
      end
    end
  rescue BadAuthorization
    library_entry_log.update(
      sync_status: :error,
      action_performed: method,
      error_message: 'Login failed'
    )
    linked_account.update(sync_to: false, disabled_reason: 'Login failed')
  rescue MediaNotFound
    library_entry_log.update(
      sync_status: :error,
      action_performed: method,
      error_message: 'Could not find MAL ID'
    )
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
    (score / 2).floor if score
  end

  private

  def get(url, profile)
    res = Typhoeus::Request.get(
      build_url(url),
      userpwd: simple_auth(profile)
    )

    check_response_status(res)

    res.response_body
  end

  def post(url, profile, body)
    res = Typhoeus::Request.post(
      build_url(url),
      userpwd: simple_auth(profile),
      body: body
    )

    check_response_status(res)

    res.response_body
  end

  def put(url, profile, body)
    res = Typhoeus::Request.put(
      build_url(url),
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      userpwd: simple_auth(profile),
      body: body
    )

    check_response_status(res)

    res.response_body
  end

  def delete(url, profile)
    res = Typhoeus::Request.delete(
      build_url(url),
      userpwd: simple_auth(profile)
    )

    check_response_status(res)

    res.response_body
  end

  def check_response_status(response)
    # HACK: this will only happen with manga if you have the score set to 0 and
    # this manga already exists on your list (PUT request).  Once you update the
    # score, this error will stop happening.
    if response.success? || (response.code == 500 && media_type == 'manga')
      library_entry_log.update(sync_status: :success, action_performed: method)
      return true
    end

    library_entry_log.update(
      sync_status: :error,
      action_performed: method,
      error_message: response.return_message.to_s
    )

    # login is broken I think
    raise BadAuthorization if response.code == 403 || response.code == 401
    # media not found
    raise MediaNotFound if response.code == 404
    # timed out
    raise TimeoutError if response.timed_out?
    # could not get an http response
    raise ConnectFailed, response.return_message.to_s if response.code.zero?
    # received a non-successful http response
    raise UnknownError, response.code
  end

  def media_type
    # anime or manga
    @media_type ||= library_entry['media_type'].underscore
  end

  def mal_media
    # convert kitsu data -> mal data
    @mal_media ||= Mapping.find_by(
      external_site: "myanimelist/#{media_type}",
      media_id: library_entry['media_id']
    )
  end

  def mal_media_id
    # will always exist because return at top
    mal_media.external_id
  end

  def linked_account
    @profile ||= User.find(library_entry['user_id']).linked_accounts.find_by(
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

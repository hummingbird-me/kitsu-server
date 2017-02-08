module DataImport
  class Kitsu
    attr_reader :hydra
    delegate :queue, :run, to: :@hydra

    # Create a new Kitsu data import processor
    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      @hydra = Typhoeus::Hydra.new(max_concurrency: 80) # hail hydra
    end

    # Retrieve the Hydra queue
    def queued
      hydra.queued_requests
    end

    # get a bunch of anime
    def get_anime(ids)
      ids = [ids] unless ids.is_a? Array

      ids.each_slice(100) do |batch|
        req = get("/api/edge/anime/?filter[id]=#{batch.join(',')}")
        req.on_complete do |res|
          anime = JSON.parse(res.body)['data']
          anime.each { |a| yield a }
        end
      end
    end

    # Get a bunch of posters
    def download_posters(ids)
      ids = [ids] unless ids.is_a? Array

      get_anime(ids) do |anime|
        file = Tempfile.new("anime_#{anime['id']}")
        file.binmode
        poster_path = %w[attributes posterImage original]
        req = get(anime.dig(*poster_path)&.sub('https:', 'http:'))
        req.on_complete do |res|
          file.write(res.body)
          yield anime, file.flush
        end
      end
    end

    private

    def get(path, opts = {})
      opts = opts.merge(accept_encoding: :gzip)
      req = Typhoeus::Request.new(build_url(path), opts)
      req.on_failure do |res|
        puts "Request failed (#{request_url(res)} => #{res.return_code})"
      end
      req.on_headers do |res|
        unless res.code == 200
          puts "Request failed (#{request_url(res)} => #{res.status_message})"
        end
      end
      queue(req)
      req
    end

    def build_url(path)
      return path if path.include?('://')
      "#{@opts[:host]}#{path}"
    end

    def request_url(res)
      req = res.is_a?(Typhoeus::Response) ? res.request : res
      url = res.is_a?(Typhoeus::Response) ? res.effective_url : res.url
      method = req.options[:method].to_s.upcase
      "#{method} #{url}"
    end
  end
end

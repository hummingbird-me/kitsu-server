module HuluImport
  class HuluSeries
    PAGE_SIZE = 2000

    # @param params [Hash] a list of params to pass in the query string to Hulu
    # @yield [HuluSeries] the series found on Hulu
    # @return [Enumerator] if no block is given, returns an Enumerator over the series list
    def self.each(params = {})
      return to_enum(__method__) unless block_given?
      params = { primary_category: 'animation', limit: PAGE_SIZE, **params }
      offset = 0
      loop do
        page = HuluImport.get('/series', offset: offset, **params)
        page['results'].each { |series| yield new(series) }
        offset += PAGE_SIZE
        break if page.length < PAGE_SIZE
      end
    end

    # @param series [Hash] the series to wrap
    def initialize(series)
      @series = series
    end

    # @return [Anime] the anime which represents this series
    def media
      @media ||= Mapping.lookup('hulu', id) ||
                 Mapping.guess('Anime', title: title, episode_count: episodes.count).tap do |media|
                   break unless media
                   break if media.OVA? || media.ONA?
                   mapping = Mapping.where(external_site: 'hulu', item: media).first_or_initialize
                   mapping.external_id = id
                   mapping.save!
                 end
    end

    # @return [Integer] the Hulu Distribution API ID for the series
    def id
      @series['id']
    end

    # @return [String] the name of the series
    def title
      @series['name']
    end

    # @return [Enumerator<Episode>] an enumerator of all the episodes in the series
    def episodes(params = {})
      @episodes ||= HuluAsset.each(series: self, series_id: id, type: 'episode', **params)
    end

    # Import all the episode & video data from Hulu
    def import!
      episodes.each(&:video!)
    end
  end
end

module HuluImport
  class HuluAsset
    PAGE_SIZE = 2000
    EID_REGEX = /.*\?eid=([^&]*).*/

    # @param series [HuluSeries] the Series to reference when performing imports
    # @param params [Hash] a list of params to pass in the query string to Hulu
    # @yield [HuluAsset] the asset found on Hulu
    # @return [Enumerator] if no block is given, returns an Enumerator over the assets list
    def self.each(series: nil, **params)
      return to_enum(:each, series: series, **params) unless block_given?
      params = { fvod: 'available', limit: PAGE_SIZE, **params }
      offset = 0
      loop do
        page = HuluImport.get('/assets', offset: offset, **params)
        page.each { |asset| yield new(asset, series: series) }
        offset += PAGE_SIZE
        break if page.length < PAGE_SIZE
      end
    end

    # @param asset [Hash] the asset to wrap
    # @param series [HuluSeries] the series to reference when performing import
    def initialize(asset, series: nil)
      @asset = asset
      @series = series
    end

    # @return [HuluSeries] the series object
    def series
      @series ||= HuluSeries.new(@asset['series'])
    end
    delegate :media, to: :series

    # @return [Integer] the number of the episode
    def number
      @asset['number']
    end

    # @return [Integer] the season number of the episode
    def season_number
      @asset.dig('season', 'number')
    end

    # @return [String] the URL to the largest thumbnail Hulu has available
    def thumbnail
      @thumbnail ||= @asset['thumbnails'].max_by { |th| th['width'] * th['height'] }['url']
    end

    # @return [Date] the original airdate of the episode
    def airdate
      Date.iso8601(@asset['original_premiere_date'])
    end

    # @return [Integer] the length, in minutes, of the episode
    def length
      # They return milliseconds
      @asset['duration'] / 60_000
    end

    # @return [String] the title of the episode
    def title
      @asset['title'].sub(/\(sub\)/i, '').strip
    end

    # @return [String] the synopsis of the episode
    def synopsis
      @asset['description']
    end

    # @return [String] the Embed ID for the video
    def eid
      EID_REGEX.match(@asset.dig('embed', 'html5'))[1]
    end

    # @return [String] the ISO language code for the dub track in this video
    def dub_language
      @asset['video_language']
    end

    # @return [String] the ISO language code for the sub track in this video
    def sub_language
      'en' if @asset['title'].downcase.include?('(sub)') || @asset['keywords'].include?('Sub')
    end

    # @return [Episode] the episode in our database which represents this asset
    def episode!
      @episode ||= Episode.where(
        media: media,
        number: number
      ).first_or_create!(
        airdate: airdate,
        thumbnail: thumbnail,
        season_number: season_number,
        length: length,
        titles: { en_jp: title },
        synopsis: synopsis
      )
    end

    # @return [Video] the video in our database which represents this asset
    def video!
      @video ||= Video.where(
        episode: episode!,
        streamer: HuluImport.streamer,
        url: @asset['link']
      ).first_or_create!(
        available_regions: %w[US],
        embed_data: { eid: eid },
        sub_lang: sub_language,
        dub_lang: dub_language
      )
    end
  end
end

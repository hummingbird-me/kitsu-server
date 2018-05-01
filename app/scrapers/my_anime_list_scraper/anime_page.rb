class MyAnimeListScraper
  class AnimePage < MediaPage
    using NodeSetContentMethod
    ANIME_URL = %r{https://myanimelist.net/anime/(?<id>\d+)/.*}

    def match?
      ANIME_URL =~ @url
    end

    def call
      super
      scrape_async "#{@url}/episode" if subtype != :movie
    end

    def import
      super
      media.age_rating ||= age_rating
      media.age_rating_guide ||= age_rating_guide
      media.episode_count ||= episode_count
      media.episode_length ||= episode_length
      media.anime_productions += productions
      media
    end

    def age_rating
      case rating_info.first
      when /\APG/i then :PG
      when /\AG\z/i then :G
      when /\AR\z/i then :R
      when /\ARx\z/i then :R18
      end
    end

    def age_rating_guide
      rating_info.last
    end

    def productions
      [
        *information['Producers'].css('a').map { |link| production_for(link, :producer) },
        *information['Licensors'].css('a').map { |link| production_for(link, :licensor) },
        *information['Studios'].css('a').map { |link| production_for(link, :studio) }
      ].compact
    end

    def episode_length
      parts = information['Duration']&.content&.split(' ')
      parts.each_cons(2).reduce(0) do |duration, (number, unit)|
        case unit
        when /\Ahr/i then duration + (number.to_i * 60)
        when /\Amin/i then duration + number.to_i
        else duration
        end
      end
    end

    def episode_count
      information['Episodes']&.content&.to_i
    end

    private

    def rating_info
      information['Rating']&.content&.split(' - ')&.map(&:strip)
    end

    def production_for(link, role)
      id = %r{producer/(\d+)/}.match(link['href'])[1]
      producer = Mapping.lookup('myanimelist/producer', id) do
        Producer.where(name: link.content).first_or_create!
      end
      AnimeProduction.new(role: role, anime: media, producer: producer)
    end

    def external_id
      ANIME_URL.match(@url)['id']
    end

    def media
      @media ||= Mapping.lookup('myanimelist/anime', external_id) || Anime.new
    end
  end
end

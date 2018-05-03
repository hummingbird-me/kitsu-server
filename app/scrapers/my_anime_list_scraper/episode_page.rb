class MyAnimeListScraper
  class EpisodePage < MyAnimeListScraper
    using NodeSetContentMethod
    EPISODE_URL = %r{\Ahttps://myanimelist.net/anime/(?<anime>\d+)/[^/]+/episode/(?<episode>\d+)\z}

    def call
      super
      import.save!
    end

    def import
      episode.titles = episode.titles.merge(titles)
      episode.canonical_title ||= 'en_jp'
      episode.synopsis ||= synopsis
      episode.length ||= length
      episode.airdate ||= airdate
      episode.number ||= number
      episode.filler ||= filler?
    end

    def match?
      EPISODE_URL =~ @url
    end

    def titles
      {
        en_us: english_title,
        en_jp: romaji_title,
        ja_jp: japanese_title
      }.compact.stringify_keys
    end

    def english_title
      # "Modern" pages on MAL have strange classes, this seems pretty rickety and may need fixing
      # if they change this later.
      main.at_css('.fs18.lh11')&.content&.split('-', 2)&.last&.strip
    end

    def japanese_title
      /.*\((.*)\)/.match(main.at_css('.di-tc .fn-grey2')&.content)[1]&.strip
    end

    def romaji_title
      /(.*)\(.*\)/.match(main.at_css('.di-tc .fn-grey2')&.content)[1]&.strip
    end

    def synopsis
      clean_text parse_sections(main.at_css('.pb8.pt8')&.children)['Synopsis']&.content&.strip
    end

    def length
      time = main.at_css(".di-tc.fn-grey2 *:contains('Duration:')")&.next&.content
      return if time.blank?
      time.split(':').reverse.reduce([1, 0]) { |(unit, length), part|
        [unit * 60, length + (unit * part.to_i)]
      }.last
    end

    def airdate
      date = main.at_css(".di-tc.fn-grey2 *:contains('Aired:')")&.next&.content
      Date.strptime(date, '%b %d, %Y') if date
    end

    def number
      /\#(\d+) - .*/.match(main.at_css('.fs18.lh11')&.content)[1].to_i
    end

    def filler?
      main.at_css(".ml8:contains('Filler')")&.content&.strip == 'Filler'
    end

    private

    def anime_id
      EPISODE_URL.match(@url)['anime']
    end

    def episode_number
      EPISODE_URL.match(@url)['episode']
    end

    def media
      @media ||= Mapping.lookup('myanimelist/anime', anime_id)
    end

    def episode
      media.episodes.where(number: episode_number).first_or_initialize
    end
  end
end

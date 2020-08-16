class MyAnimeListScraper
  class EpisodePage < MyAnimeListScraper
    using NodeSetContentMethod
    EPISODE_URL = %r{\Ahttps://myanimelist.net/anime/(?<anime>\d+)/[^/]+/episode/(?<episode>\d+)\z}

    def call
      super
      # Bail out if the horiznav item isn't activated (page is empty)
      return unless page.at_css('.horiznav_active').present?
      # Bail out if MAL has no data
      return if /to have any episode information yet/i =~ page.at_css('.badresult')&.content
      import.save!
    end

    def import
      episode.titles = episode.titles.merge(titles)
      episode.canonical_title = canonical_title
      episode.description['en'] ||= synopsis
      episode.length ||= length
      episode.airdate ||= airdate
      episode.number ||= number
      episode.filler ||= filler?
      episode
    end

    def match?
      EPISODE_URL =~ @url
    end

    def canonical_title
      if titles['en_jp'].present?
        'en_jp'
      elsif titles['en_us'].present? && /\AEpisode \d+/ !~ titles['en_us']
        'en_us'
      elsif titles['ja_jp'].present?
        'ja_jp'
      end
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
      main.at_css('.fs18.lh11')&.xpath('./text()')&.content&.strip
    end

    def japanese_title
      /.*\((.*)\)/.match(main.at_css('.di-tc .fn-grey2')&.content)&.[](1)&.strip
    end

    def romaji_title
      /(.*)\(.*\)/.match(main.at_css('.di-tc .fn-grey2')&.content)&.[](1)&.strip
    end

    def synopsis
      text = parse_sections(main.at_css('.pb8.pt8')&.children)['Synopsis']&.content&.strip

      return if EMPTY_TEXT =~ text

      clean_text(text)
    end

    def length
      time = main.at_css(".di-tc.fn-grey2 *:contains('Duration:')")&.next&.content
      return if time.blank?

      length = time.split(':').reverse.reduce([1, 0]) { |(unit, length), part|
        [unit * 60, length + (unit * part.to_i)]
      }.last
      length if length > 0
    end

    def airdate
      date = main.at_css(".di-tc.fn-grey2 *:contains('Aired:')")&.next&.content
      Date.strptime(date, '%b %d, %Y') if date && !date.include?('N/A')
    end

    def number
      /\#(\d+) - .*/.match(main.at_css('.fs18.lh11')&.content)[1].to_i
    end

    def filler?
      main.at_css(".ml8:contains('Filler')")&.content&.strip == 'Filler' ||
        main.at_css(".ml8:contains('Recap')")&.content&.strip == 'Recap'
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
      @episode ||= media.episodes.where(number: episode_number).first_or_initialize
    end
  end
end

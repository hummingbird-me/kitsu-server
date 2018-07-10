class MyAnimeListScraper
  class CharacterPage < MyAnimeListScraper
    using NodeSetContentMethod
    CHARACTER_URL = %r{\Ahttps://myanimelist.net/character/(?<id>\d+)/[^/]+\z}

    def match?
      CHARACTER_URL =~ @url
    end

    def call
      super
      import.save!
    end

    def import
      character.names = character.names.merge(names)
      character.canonical_name ||= 'en'
      character.description ||= description
      character.image ||= image
    end

    def names
      {
        en: english_name,
        ja_jp: japanese_name
      }
    end

    def english_name
      main.at_css('.breadcrumb + .normal_header').xpath('./text()').content.strip
    end

    def japanese_name
      name = main.at_css('.breadcrumb + .normal_header small')&.content&.strip
      /\((.*)\)/.match(name)[1] if name
    end

    def description
      clean_html(main_sections[english_name].to_html)
    end

    def image
      return nil if sidebar.at_css('.btn-detail-add-picture').present?
      URI(sidebar.at_css('img')['src'].sub(/(\.[a-z]+)\z/i, 'l\1'))
    end

    private

    def external_id
      CHARACTER_URL.match(@url)['id']
    end

    def character
      @character ||= Mapping.lookup('myanimelist/character', external_id) ||
                     Character.where(mal_id: external_id) ||
                     Character.new(mal_id: external_id)
    end
  end
end

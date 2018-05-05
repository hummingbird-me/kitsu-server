class MyAnimeListScraper
  class PersonPage < MyAnimeListScraper
    include SidebarKeyValueParser
    using NodeSetContentMethod
    PERSON_URL = %r{\Ahttps://myanimelist.net/people/(?<id>\d+)/[^/]+\z}

    def match?
      PERSON_URL =~ @url
    end

    def call
      super
      import.save!
    end

    def import
      person.names = person.names.merge(names)
      person.canonical_name ||= 'en'
      person.description ||= description
      person.image ||= image
    end

    def names
      {
        en: english_name,
        ja_jp: japanese_name
      }
    end

    def english_name
      header.split(',', 2).reverse.map(&:strip).join(' ')
    end

    def japanese_name
      given_name = sidebar_data['Given name']&.content&.strip
      family_name = sidebar_data['Family name']&.content&.strip
      "#{family_name} #{given_name}" if given_name && family_name
    end

    def description
      # Yes, that says "informa*n*tion".  Yes, that's how MAL spells it.
      clean_html(sidebar.at_css('.people-informantion-more').to_html)
    end

    def birthday
      date = sidebar_data['Birthday']&.content&.strip
      Date.strptime(date, '%b %e, %Y') if date
    end

    def image
      return nil if sidebar.at_css('.btn-detail-add-picture').present?
      URI(sidebar.at_css('img')['src'].sub(/(\.[a-z]+)\z/i, 'l\1'))
    end

    private

    def sidebar_data
      @sidebar_data ||= hash_for_sidebar_section(nil)
    end

    def external_id
      CHARACTER_URL.match(@url)['id']
    end

    def person
      @person ||= Mapping.lookup('myanimelist/person', external_id) || Person.new
    end
  end
end

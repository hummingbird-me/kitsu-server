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
      create_mapping('myanimelist/people', external_id, person)
    end

    def import
      person.name = english_name
      person.names = person.names.merge(names).compact
      person.canonical_name ||= 'en'
      person.description ||= description
      person.image = image unless person.image.present?
      person.staff ||= staff
      person.birthday ||= birthday
      person
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
      return if /Unknown/i =~ date
      Date.strptime(date, '%b %e, %Y') if date
    rescue ArgumentError
      nil
    end

    def image
      return nil if sidebar.at_css('.btn-detail-add-picture').present?
      URI(sidebar.at_css('img')['src'].sub(/(\.[a-z]+)\z/i, 'l\1'))
    end

    def staff
      rows = main_sections['Anime Staff Positions'].css('tr > td:last-child')
      roles = rows.each_with_object({}) do |row, acc|
        anime = object_for_link(row.at_css("a[href*='/anime/']"))
        role = row.at_css('small')
        acc[anime] ||= MediaStaff.where(media: anime, person: person).first_or_initialize
        # TODO: switch to an array for the roles
        acc[anime].role ||= ''
        acc[anime].role += ", #{role}"
      end
      roles.values
    end

    private

    def sidebar_data
      @sidebar_data ||= hash_for_sidebar_section(nil)
    end

    def external_id
      PERSON_URL.match(@url)['id']
    end

    def person
      @person ||= Mapping.lookup('myanimelist/people', external_id) || Person.new
    end
  end
end

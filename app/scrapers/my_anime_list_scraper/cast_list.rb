class MyAnimeListScraper
  class CastList < MyAnimeListScraper
    using NodeSetContentMethod
    CAST_LIST_URL = %r{\Ahttps://myanimelist.net/anime/(?<anime>\d+)/[^/]+/characters\z}

    def call
      super
      if media
        media.characters += characters
        media.save!
      end
      scrape_async(*character_urls)
      scrape_async(*people_urls)
    end

    def characters
      chars = main_sections['Characters & Voice Actors'].css('table').map do |row|
        # Build the MediaCharacter
        character = object_for_link(row.at_css("a[href*='/character/']"))
        next unless character
        media_char = media.characters.where(character: character).first_or_initialize
        role = row.at_css("a[href*='/character/'] + .spaceit_pad > small").content
        media_char.role = role.underscore.to_sym

        voices = row.css("td.borderClass[align='right']").map do |person_row|
          # Build the CharacterVoice
          person = object_for_link(person_row.at_css("a[href*='/people/']"))
          next unless person
          media_char.voices.where(person: person).first_or_initialize do |voice|
            language = person_row.at_css("a[href*='/people/'] ~ small")&.content&.strip
            voice.locale = LANGUAGES[language]
          end
        end
        media_char.voices = [*media_char.voices, *voices].compact.uniq
        media_char
      end
      chars.compact.uniq
    end

    def staff
      staff = main_sections['Staff'].css('table').map do |row|
        person = object_for_link(row.at_css("a[href*='/people/']"))
        next unless person
        media_staff = media.staff.where(person: person).first_or_initialize
        role = row.at_css('small').content
        media_staff.role = role

        media_staff
      end
      staff.compact.uniq
    end

    def match?
      CAST_LIST_URL =~ @url
    end

    private

    def media
      @media ||= Mapping.lookup('myanimelist/anime', media_id)
    end

    def media_id
      id_for_url(@url, 'anime')
    end

    def character_urls
      main.css("a[href*='/character/']").map { |a| a['href'] }.uniq
    end

    def people_urls
      main.css("a[href*='/people/']").map { |a| a['href'] }.uniq
    end
  end
end

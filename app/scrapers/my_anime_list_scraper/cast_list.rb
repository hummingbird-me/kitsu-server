class MyAnimeListScraper
  class CastList < MyAnimeListScraper
    using NodeSetContentMethod
    CAST_LIST_URL = %r{\Ahttps://myanimelist.net/(?<kind>[a-z]+)/(?<id>\d+)/[^/]+/characters\z}

    def call
      super
      if media
        media.characters += characters
        media.staff += staff
        media.save!
      end
      scrape_async(*character_urls)
      scrape_async(*people_urls)
    end

    def characters
      chars = character_rows.map do |row|
        # Build the MediaCharacter
        character = object_for_link(row.at_css("a[href*='/character/']"))
        next unless character
        media_char = media.characters.where(character: character).first_or_initialize
        role = row.at_css("a[href*='/character/'] + .spaceit_pad > small").content
        media_char.role = role.underscore.to_sym

        voices = process_voice_rows(row, media_char)
        media_char.voices = [*media_char.voices, *voices].compact.uniq if voices
        media_char
      end
      chars.compact.uniq
    end

    def staff
      return [] if staff_rows.blank?
      staff = staff_rows.map do |row|
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

    def process_voice_rows(character_row, media_char)
      return nil unless character_row.at_css("a[href*='/people/']").present?
      character_row.css("td.borderClass[align='right']").map do |person_row|
        # Build the CharacterVoice
        person = object_for_link(person_row.at_css("a[href*='/people/']"))
        next unless person
        media_char.voices.where(person: person).first_or_initialize do |voice|
          language = person_row.at_css("a[href*='/people/'] ~ small")&.content&.strip
          voice.locale = LANGUAGES[language]
        end
      end
    end

    def staff_rows
      main_sections['Staff']&.css('table')
    end

    def character_rows
      (main_sections['Characters & Voice Actors'] || main_sections['Characters'])&.css('table')
    end

    def media
      @media ||= object_for_link(@url)
    end

    def character_urls
      main.css("a[href*='/character/']").map { |a| a['href'] }.uniq
    end

    def people_urls
      main.css("a[href*='/people/']").map { |a| a['href'] }.uniq
    end
  end
end

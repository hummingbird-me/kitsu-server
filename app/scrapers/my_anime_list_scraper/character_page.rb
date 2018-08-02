class MyAnimeListScraper
  class CharacterPage < MyAnimeListScraper
    using NodeSetContentMethod

    CHARACTER_URL = %r{\Ahttps://myanimelist.net/character/(?<id>\d+)/[^/]+\z}

    def match?
      CHARACTER_URL =~ @url
    end

    def call
      return if /Invalid ID/i =~ page.at_css('.badresult')&.content
      super
      import.save!
      create_mapping('myanimelist/character', external_id, character)
    end

    def import
      character.names = character.names.merge(names)
      character.canonical_name ||= 'en'
      character.description ||= description
      character.image = image unless character.image.present?
      character.media_characters += media_characters
      character.media_characters.uniq!
      character
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
      return if /No biography/i =~ main_sections[english_name].content
      clean_html(main_sections[english_name].to_html)
    end

    def image
      return nil if sidebar.at_css('.btn-detail-add-picture').present?
      src = sidebar.at_css('img')['src']
      URI(src) unless %r{images/questionmark} =~ src
    end

    def media_characters
      ography_roles_for('Manga') + ography_roles_for('Anime')
    end

    def ography_roles_for(type)
      rows = sidebar.css(".normal_header:contains('#{type}ography') + table tr > td:last-child")
      return [] if rows.blank?
      out = rows.map do |row|
        # Extract
        url = row.at_css("a[href*='/#{type.downcase}/']")['href']
        id = %r{/#{type.downcase}/(\d+)/}.match(url)[1]
        role = row.at_css('small').content.strip.downcase.to_sym

        # Transform
        media = Mapping.lookup("myanimelist/#{type.downcase}", id)
        if media.blank?
          scrape_async(url)
          next
        end

        # Load
        char = MediaCharacter.where(media: media).first_or_initialize
        char.role = role
        char
      end
      out.compact
    end

    private

    def external_id
      CHARACTER_URL.match(@url)['id']
    end

    def character
      @character ||= Mapping.lookup('myanimelist/character', external_id) ||
                     Character.where(mal_id: external_id).first_or_initialize
    end
  end
end

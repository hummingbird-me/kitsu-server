class MyAnimeListScraper
  class MangaPage < MediaPage
    using NodeSetContentMethod
    MANGA_URL = %r{\Ahttps://myanimelist.net/manga/(?<id>\d+)/[^/]+\z}
    AUTHOR_ROLE_REGEX = /\((?<role>[^)]+)\)/

    def match?
      MANGA_URL =~ @url
    end

    def call
      super
      create_mapping('myanimelist/manga', external_id, media)
      scrape_async(*staff_urls)
    end

    def import
      super
      media.volume_count ||= volume_count
      media.chapter_count ||= chapter_count
      media.start_date ||= start_date
      media.end_date ||= end_date
      media.staff = staff
      media
    end

    def staff
      # We have to iterate over each node in the HTML and match people to their roles
      staff = information['Authors'].each_with_object([]) do |node, acc|
        if node.text? && AUTHOR_ROLE_REGEX =~ node.content
          # If it's a text node, check if it's got a "(Role)"
          role = AUTHOR_ROLE_REGEX.match(node.content)[1]
          # The accumulator is an array of [person, role] pairs
          acc.last[1] = role
        elsif node.name == 'a'
          # If it's a link, extract the person data
          person_id = %r{/people/(\d+)/.*}.match(node['href'])[1]
          # Find the person and add them to our accumulator
          person = Mapping.lookup('myanimelist/people', person_id)
          acc << [person, '']
        end
      end
      # Strip out staff we couldn't find in our own database
      staff = staff.select { |(person, _)| person.present? }
      # Build the MangaStaff instances
      staff.map do |(person, role)|
        MediaStaff.where(person: person, media: media).first_or_create(role: role)
      end
    end

    def chapter_count
      count = information['Chapters']&.content&.strip
      return if count == 'Unknown'
      count&.to_i
    end

    def volume_count
      count = information['Volumes']&.content&.strip
      return if count == 'Unknown'
      count&.to_i
    end

    def start_date
      published[0]
    end

    def end_date
      published[1]
    end

    private

    def staff_urls
      information['Authors'].css("a[href*='/people/']").map { |a| a['href'] }.uniq
    end

    def external_id
      MANGA_URL.match(@url)['id']
    end

    def published
      @published ||= parse_date_range(information['Published']&.content)
    end

    def media
      @media ||= Mapping.lookup('myanimelist/manga', external_id) || Manga.new
    end
  end
end

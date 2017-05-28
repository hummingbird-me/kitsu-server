class MyAnimeListXmlGeneratorService
  attr_reader :library, :media_type

  def initialize(library, media_type)
    @library = library
    @media_type = media_type
  end

  # rubocop:disable Style/BlockDelimiters
  def generate_xml
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.myanimelist {
        xml.myinfo {
          user_export_type(xml)
        }

        library.each do |library_entry|
          # get the mal id
          mal_id = mal_external_site(library_entry)
          # skip entry if it doesn't exist
          # will need to update the log relating to this
          next unless mal_id

          # will create an anime or manga xml tag
          xml.public_send(media_type) {
            # series_animedb_id or manga_mangadb_id
            mal_media_id(xml, mal_id)
            # my_watched_episodes or my_read_chapters
            progress(xml, library_entry.progress)
            # my_start_date
            started_at(xml, library_entry.started_at)
            # my_finish_date
            finished_at(xml, library_entry.finished_at)
            # my_score
            rating(xml, library_entry.rating)
            # my_status
            status(xml, library_entry.status)
            # my_times_watched or my_times_read
            reconsume_count(xml, library_entry.reconsume_count)
            # required by mal so it updates this entry
            xml.update_on_import 1
          }
        end
      }
    end

    puts builder.to_xml
    raise
  end

  def user_export_type(xml)
    case media_type
    when 'anime'
      xml.user_export_type 1
    when 'manga'
      xml.user_export_type 2
    end
  end

  def mal_external_site(library_entry)
    library_entry.media.mappings.where(
      external_site: "myanimelist/#{media_type}"
    )&.external_id
  end

  def mal_media_id(xml, id)
    case media_type
    when 'anime'
      xml.series_animedb_id id
    when 'manga'
      xml.manga_mangadb_id id
    end
  end

  def progress(xml, progress)
    case media_type
    when 'anime'
      xml.my_watched_episodes progress
    when 'manga'
      xml.my_read_chapters progress
    end
  end

  def started_at(xml, started_at)
    return unless started_at

    xml.my_start_date started_at.strftime('%Y-%m-%d')
  end

  def finished_at(xml, finished_at)
    return unless finished_at

    xml.my_finish_date finished_at.strftime('%Y-%m-%d')
  end

  def rating(xml, rating)
    xml.my_score rating if rating
  end

  def status(xml, status)
    xml.my_status format_status(status)
  end

  def format_status(status)
    # change our status -> mal status
    case status
    # watching/reading
    when 'current' then media_type == 'anime' ? 'Watching' : 'Reading'
    # plan to watch/plan to read
    when 'planned' then media_type == 'anime' ? 'Plan to Watch' : 'Plan to Read'
    when 'completed' then 'Completed'
    when 'on_hold' then 'On Hold'
    when 'dropped' then 'Dropped'
    end
  end

  def reconsume_count(xml, reconsume_count)
    return unless reconsume_count

    case media_type
    when 'anime'
      xml.my_times_watched reconsume_count
    when 'manga'
      xml.my_times_read reconsume_count
    end
  end
end

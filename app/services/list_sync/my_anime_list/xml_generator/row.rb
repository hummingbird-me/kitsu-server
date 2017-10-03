module ListSync
  class MyAnimeList
    class XmlGenerator
      class Row
        attr_reader :entry, :kind, :media, :mapping

        def initialize(entry)
          @entry = entry
          @kind = entry.kind
          @media = entry.media
          @mapping = media.mapping_for("myanimelist/#{kind}")
        end

        # Generates a Hash with the keys which MyAnimeList's XML export wants
        def to_h
          return unless mapping
          [
            media_id, progress, notes, volumes_owned, started_at, finished_at, rating, status,
            reconsume_count, update_on_import
          ].reduce(&:merge).compact
        end

        # Calls {#to_h} and converts it into this form of XML:
        #
        #   <kind>
        #     <key>value</key>
        #     <key>value</key>
        #     ...
        #   </kind>
        def to_xml
          return unless mapping
          Nokogiri::XML::Builder.new { |xml|
            xml.public_send(kind) do
              to_h.each { |k, v| xml.public_send(k, v) }
            end
          }.doc.root.to_xml
        end

        private

        def update_on_import
          { update_on_import: 1 }
        end

        def media_id
          case kind
          when :anime then { series_animedb_id: mapping.external_id }
          when :manga then { manga_mangadb_id: mapping.external_id }
          end
        end

        def progress
          case kind
          when :anime then { my_watched_episodes: entry.progress }
          when :manga then { my_read_chapters: entry.progress }
          end
        end

        def notes
          return {} unless entry.notes
          notes = entry.notes.split("\n=== MAL Tags ===\n")
          return { my_comments: notes[0], my_tags: notes[1] } if notes.length > 1
          { my_comments: notes[0], my_tags: notes[0] }
        end

        def volumes_owned
          { my_read_volumes: entry.volumes_owned }
        end

        def started_at
          { my_start_date: entry.started_at&.strftime('%F') }
        end

        def finished_at
          { my_finish_date: entry.finished_at&.strftime('%F') }
        end

        def rating
          { my_score: (entry.rating && entry.rating / 2) }
        end

        def status
          verb = kind == :manga ? 'Read' : 'Watch'
          mal_status = case entry.status
                       when 'current' then "#{verb}ing"
                       when 'planned' then "Plan to #{verb}"
                       when 'completed' then 'Completed'
                       when 'on_hold' then 'On Hold'
                       when 'dropped' then 'Dropped'
                       end

          { my_status: mal_status }
        end

        def reconsume_count
          case kind
          when :anime then { my_times_watched: entry.reconsume_count }
          when :manga then { my_times_read: entry.reconsume_count }
          end
        end
      end
    end
  end
end

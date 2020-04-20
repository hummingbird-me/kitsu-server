# frozen_string_literal: true

class ListImport
  class AnilistV2
    class Row
      def initialize(node, type)
        @node = node
        @type = type.to_s # anime | manga
      end

      def media_mapping
        anilist_mapping = Mapping.lookup(anilist_key, media.id)

        return anilist_mapping if anilist_mapping.present?

        other_mapping = Mapping.lookup(mal_key, mal_id) ||
                        Mapping.guess(type.classify.safe_constantize, media_info)

        Mapping.create(item: other_mapping, external_site: anilist_key, external_id: media.id) if other_mapping.present?
        other_mapping
      end

      def data
        fields.map { |field| [field, send(field)] }.to_h.compact
      end

      private

      attr_reader :node, :type

      def fields
        %i[
          rating status reconsume_count progress
          notes started_at finished_at
        ]
      end

      # For mapping guess
      def media_info
        {
          title: title,
          subtype: type,
          episode_count: media.episodes,
          chapter_count: media.chapters
        }.compact
      end

      # 100-point scale to 20-point scale (raw)
      # rating -> score
      def rating
        return nil if node.score.zero?

        [(node.score.to_f / 5).ceil, 2].max
      end

      def status
        case node.status.downcase
        when 'completed' then :completed
        when 'current' then :current
        when 'planning' then :planned
        when 'paused' then :on_hold
        when 'dropped' then :dropped
        end
      end

      # reconsume_count -> repeat
      def reconsume_count
        node.repeat
      end

      def progress
        node.progress
      end

      def notes
        node.notes
      end

      # 2020-05-19 -> yyyy-mm-dd
      def started_at
        return if node.started_at.to_h.compact.blank?

        # will properly convert to include 0 before days/months
        formatted_date(node.started_at)
      end

      # finished_at -> completed_at
      def finished_at
        return if node.completed_at.to_h.compact.blank?

        # will properly convert to include 0 before days/months
        formatted_date(node.completed_at)
      end

      def formatted_date(date_node)
        date_node.to_h.values_at(:year, :month, :day).join('-').to_date.to_s
      end

      def anilist_key
        "AniList/#{type}"
      end

      def mal_key
        "MyAnimeList #{type.capitalize}"
      end

      def media
        node.media
      end

      def mal_id
        media.id_mal
      end

      def titles
        media.title
      end

      def title
        titles.romaji.presence ||
          titles.english.presence ||
          titles.native.presence ||
          titles.user_preferred
      end
    end
  end
end

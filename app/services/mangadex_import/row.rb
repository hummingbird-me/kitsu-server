class MangadexImport
  class Row
    LANGUAGES = {
      'Brazilian' => 'pt_br',
      'Chinese (Simp)' => 'zh_Hans',
      'English' => 'en',
      'French' => 'fr',
      'German' => 'de',
      'Hebrew' => 'he',
      'Hungarian' => 'hu',
      'Indonesian' => 'id_in',
      'Italian' => 'it',
      'Japanese' => 'ja_jp',
      'Korean' => 'ko',
      'Malay' => 'ms',
      'Spanish' => 'es',
      'Thai' => 'th'
    }.freeze

    attr_reader :kitsu_data, :mangadex_data

    def initialize(kitsu_data, mangadex_data)
      @kitsu_data = kitsu_data
      @mangadex_data = mangadex_data
    end

    def create_or_update
      kitsu_generic_fields.each do |kitsu_field|
        kitsu_data[kitsu_field] ||= public_send("mangadex_#{kitsu_field}")
      end

      kitsu_data.abbreviated_titles = mangadex_abbreviated_titles
      kitsu_data.chapter_count = mangadex_chapter_count
      kitsu_data.titles[kitsu_data.canonical_title] ||= mangadex_titles
    end

    def kitsu_generic_fields
      %w[
        age_rating canonical_title
        end_date original_locale poster_image_file_name
        serialization slug start_date subtype synopsis
        volume_count
      ]
    end

    def mangadex_age_rating
      mangadex['hentai'] ? 'R18' : nil
    end

    def mangadex_abbreviated_titles
      kitsu_data.abbreviated_titles.concat(mangadex['alt_titles']).uniq
    end

    def mangadex_canonical_title
      LANGUAGES[mangadex_original_locale]
    end

    def mangadex_chapter_count
      [kitsu_data.chapter_count, mangadex['total_chapters']].max
    end

    def mangadex_original_locale
      mangadex['title']['origin']
    end

    def mangadex_poster_image_file_name
      mangadex['thumbnail']
    end

    def mangadex_serialization
      nil
    end

    def mangadex_slug
      mangadex['title']['slug']
    end

    def mangadex_subtype
      'manga'
    end

    # TODO: do we need to sanitize?
    def mangadex_synopsis
      mangadex['description']
    end

    def mangadex_titles
      mangadex['title']['name']
    end

    def mangadex_volume_count
      nil
    end
  end
end

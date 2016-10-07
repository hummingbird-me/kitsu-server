# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  error_message           :text
#  error_trace             :text
#  input_file_content_type :string
#  input_file_file_name    :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  progress                :integer
#  status                  :integer          default(0), not null
#  strategy                :integer          not null
#  total                   :integer
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer          not null
#
# rubocop:enable Metrics/LineLength

class ListImport
  class AnimePlanet < ListImport
    ANIME_PLANET_HOST = 'http://www.anime-planet.com/users/'.freeze

    def count(external_id)
      get(external_id).css('.pagination + p').children.first.text.to_i
    end

    def each(external_id)
      get()
        row = Row.new(media)
        yield row.media, row.data
    end

    # private

    def get(url, opts = {})
      Nokogiri::HTML(
        Typhoeus::Request.get(
            "#{build_url(url)}",
            {
              cookiefile: "/tmp/anime-planet-cookies",
              cookiejar: "/tmp/anime-planet-cookies",
              followlocation: true
            }.merge(opts)
        ).body
      )
    end

    def build_url(path, page = 1)
      # toyhammered/anime
      extensions = "?sort=title&mylist_view=list&per_page=480&page=#{page}"
      "#{ANIME_PLANET_HOST}#{path}#{extensions}"
    end

  end
end

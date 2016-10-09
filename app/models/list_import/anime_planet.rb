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

    attr_reader :username

    def initialize(username)
      @username = username
    end

    def count
      # can I just loop twice for anime/manga?
      # get(username).css('.pagination + p').children.first.text.to_i
    end

    def each
      %w[anime manga].each do |type|
        amount = get("#{username}/#{type}").css('.pagination li').map(&:content).map(&:to_i).max

        amount.times do |page|
          get("#{username}/#{type}", page + 1).css('table.personalList tr:nth-child(n+2)').each do |line|
            row = Row.new(line, type)
            # yield row.media, row.data
            yield row.data
          end
        end
      end
    end

    # private

    def get(url, page = 1, view = 'list', opts = {})
      Nokogiri::HTML(
        Typhoeus::Request.get(
            "#{build_url(url, page)}",
            {
              cookiefile: "/tmp/anime-planet-cookies",
              cookiejar: "/tmp/anime-planet-cookies",
              followlocation: true
            }.merge(opts)
        ).body
      )
    end

    def build_url(path, page)
      # toyhammered/anime
      extensions = "?mylist_view=list&per_page=480&sort=title&page=#{page}"
      "#{ANIME_PLANET_HOST}#{path}#{extensions}"
    end

  end
end

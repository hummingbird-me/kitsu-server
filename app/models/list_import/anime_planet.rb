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

    # accepts a username as input
    validates :input_text, length: {
      minimum: 3,
      maximum: 20
    }, presence: true
    # does not accept file uploads

    def count
      %w[anime manga].map { |type|
        get("#{input_text}/#{type}").css('.pagination + p')
                                    .children.first.text.to_i
      }.inject(&:+)
    end

    def each
      %w[anime manga].each do |type|
        amount = get("#{input_text}/#{type}").css('.pagination li')
          &.map(&:content)
          &.map(&:to_i)
          &.max
        amount ||= 1

        1.upto(amount) do |page|
          get("#{input_text}/#{type}", page).css('.cardDeck .card').each do |card|
            row = Row.new(card, type)
            # yield row.media, row.data
            yield row.media
          end
        end
      end
    end

    # private

    def get(url, page = 1, opts = {})
      Nokogiri::HTML(
        Typhoeus::Request.get(
          build_url(url, page),
            {
              cookiefile: '/tmp/anime-planet-cookies',
              cookiejar: '/tmp/anime-planet-cookies',
              followlocation: true
            }.merge(opts)
        ).body
      )
    end

    def build_url(path, page)
      # toyhammered/anime
      extensions = "?mylist_view=grid&per_page=480&sort=title&page=#{page}"
      "#{ANIME_PLANET_HOST}#{path}#{extensions}"
    end
  end
end

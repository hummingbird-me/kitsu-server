class ListImport
  class AnimePlanet < ListImport
    ANIME_PLANET_HOST = "http://#{ENV.fetch('ANIME_PLANET_PROXY_HOST', nil)}/users/".freeze

    # accepts a username as input
    validates :input_text, length: {
      minimum: 3,
      maximum: 20
    }, presence: true
    # does not accept file uploads
    validates :input_file_data, absence: true
    validate :ensure_user_exists, on: :create

    def ensure_user_exists
      return if input_text.blank?
      request = Typhoeus::Request.get(build_url("#{input_text}/anime", 1))
      case request.code
      when 404
        errors.add(:input_text, 'Anime-Planet user not found')
      end
    end

    def count
      @count ||= %w[anime manga].map { |type|
        page = get("#{input_text}/#{type}")
        return 0 if page.css('h3:contains("doesn\'t have")').present?
        page.css('.pagination + p').children.first.text.to_i
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
            yield row.media, row.data
          end
        end
      end
    end

    private

    def get(url, page = 1, opts = {})
      url = build_url(url, page)
      request = Typhoeus::Request.get(url, {
        cookiefile: '/tmp/anime-planet-cookies',
        cookiejar: '/tmp/anime-planet-cookies',
        userpwd: ENV.fetch('ANIME_PLANET_PROXY_AUTH', nil),
        followlocation: true
      }.merge(opts).compact)
      Nokogiri::HTML(request.body)
    end

    def build_url(path, page)
      # toyhammered/anime
      extensions = "?mylist_view=grid&per_page=480&sort=title&page=#{page}"
      "#{ANIME_PLANET_HOST}#{path}#{extensions}"
    end
  end
end

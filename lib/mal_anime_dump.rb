class MalAnimeDump
  class DumpFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read).deep_symbolize_keys
    end

    def producers
      %i[producer licensor studio].map { |role|
        key = role.to_s.pluralize.to_sym
        data[key].map do |producer_name|
          producer = Producer.where(name: producer_name).first_or_initialize
          production = anime.anime_productions.where(producer: producer)
                            .first_or_initialize
          production.role = role
          production
        end
      }.flatten
    end

    def genres
      Genre.where(name: data[:genres])
    end

    def age_rating
      return [nil, nil] unless data['classification']
      rating, reason = data['classification'].split(' - ')

      rating = case rating[0]
               when 'G', 'TV-Y7' then :G
               when 'PG', 'PG13', 'PG-13' then :PG
               when 'R', 'R+' then :R
               when 'Rx' then :R18
               end
      [rating, reason]
    end

    def anime
      @anime ||= Mapping.lookup('myanimelist', "anime/#{mal_id}") ||
                 Anime.where('avals(titles) @> ARRAY[?]', titles).first ||
                 Anime.new
    end

    def titles
      [data[:title]] + data[:other_titles].values.flatten
    end

    def mal_id
      data[:id]
    end

    def youtube_video_id
      data[:preview]&.split('/')&.last
    end

    def subtype
      return unless data[:type]
      type = data[:type].downcase
      case type
      when 'tv' then :TV
      when 'ova' then :OVA
      when 'ona' then :ONA
      else type.to_sym
      end
    end

    def episode_count
      return nil if data[:episodes].zero?
      data[:episodes]
    end

    def apply!
      puts "#{data[:title]} => #{anime.canonical_title || 'new'}"
      anime.assign_attributes(
        synopsis: Nokogiri::HTML.fragment(data[:synopsis]).text,
        episode_count: episode_count,
        episode_length: data[:duration],
        subtype: subtype,
        start_date: parse_date(data[:start_date]),
        end_date: parse_date(data[:end_date]),
        age_rating: age_rating[0],
        age_rating_guide: age_rating[1],
        youtube_video_id: youtube_video_id,
        genres: genres,
        titles: {
          ja_jp: data[:other_titles][:japanese],
          ja_en: data[:title],
          en: data[:other_titles][:english]
        },
        abbreviated_titles: data[:other_titles][:synonyms],
        canonical_title: 'ja_en'
      )
      producers
      anime.poster_image = data[:image_url] if anime.poster_image.blank?
      anime.genres = genres
      anime.save!
      anime.mappings.where(external_site: 'myanimelist',
                           external_id: "anime/#{mal_id}").first_or_create
      anime
    rescue ActiveRecord::RecordNotUnique
      puts 'Uniqueness failed'
    end

    private

    def parse_date(date)
      Date.new(*date.split('-').map(&:to_i)) if date
    end
  end

  def initialize(dir)
    @dir = dir || ENV['MAL_DUMP_DIRECTORY']
  end

  def run!
    dir = @dir
    files = Dir.entries(@dir)
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    bar = ProgressBar.create(
      title: 'Importing',
      total: files.count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
    files.each do |filename|
      filename = File.join(dir, filename)
      DumpFile.new(filename).apply! if File.file?(filename)
      bar.increment
    end
    Anime.connection.reconnect!
  end
end

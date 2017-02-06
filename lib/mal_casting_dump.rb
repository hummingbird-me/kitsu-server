class MalCastingDump
  class DumpFile
    attr_reader :data, :filename

    def initialize(filename)
      @filename = filename
      @data = JSON.parse(open(filename).read).deep_symbolize_keys
    end

    def castings_for(character, actors)
      actors.map do |actor|
        locale = locale_for(actor[:language])
        puts "   --> #{actor[:name]} (#{locale})"
        AnimeCasting.where(
          person: person_for(actor),
          anime_character: character,
          locale: locale
        ).first_or_create
      end
    end

    def anime
      @anime ||= Mapping.lookup('myanimelist/anime', mal_id)
    end

    def mal_id
      File.basename(filename, '.*').to_i
    end

    def apply!
      puts "=> #{anime&.canonical_title}"
      data[:Characters]&.map do |char|
        puts "  -> #{char[:name]}"
        character = character_for(char)
        AnimeCharacter.where(
          anime: anime,
          character: character,
        ).first_or_create(role: char[:role].downcase)
        castings_for(character, char[:actors]) if char[:actors].present?
      end
      data[:Staff]&.map do |staff|
        puts "=> #{staff[:name]}"
        person = person_for(staff)
        AnimeStaff.where(
          anime: anime,
          person: person,
          role: staff[:rank]
        ).first_or_create
      end
    rescue ActiveRecord::RecordNotUnique
      puts 'Uniqueness failed'
    rescue OpenURI::HTTPError
      puts 'File not found'
    end

    private

    def flip_name(name)
      name.split(',').map(&:strip).reverse.join(' ')
    end

    def character_for(data)
      Character.where(mal_id: data[:id]).first_or_create(
        name: flip_name(data[:name]),
        image: image_for(data[:image])
      )
    end

    def person_for(data)
      Person.where(mal_id: data[:id]).first_or_create(
        name: flip_name(data[:name]),
        image: image_for(data[:image])
      )
    end

    def locale_for(language)
      case language
      when 'Japanese' then 'ja'
      when 'English' then 'en'
      when 'French' then 'fr'
      when 'Brazilian' then 'pt_br'
      when 'German' then 'de'
      when 'Hebrew' then 'iw'
      when 'Hungarian' then 'hu'
      when 'Italian' then 'it'
      when 'Korean' then 'ko'
      when 'Spanish' then 'es'
      end
    end

    def image_for(url)
      url unless url.include?('questionmark')
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
  end
end

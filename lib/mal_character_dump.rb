class MalCharacterDump
  class DumpFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read).deep_symbolize_keys
    end

    def character
      @character ||= Character.find_by(mal_id: data[:id]) || Character.new
    end

    def apply!
      puts data[:titles][:canonical]

      character.description ||= data[:description]
      character.image = data[:image] if character.image.blank?
      character.name ||= data[:titles][:canonical]
      character.mal_id ||= data[:id]
      character.save
    rescue ActiveRecord::RecordNotUnique
      puts 'Uniqueness failed'
    rescue OpenURI::HTTPError
      puts 'OpenURI Error'
    end
  end

  def initialize(dir)
    @dir = dir || ENV['MAL_DUMP_DIRECTORY']
  end

  def run!
    dir = @dir
    files = Dir.entries(@dir)
    ActiveRecord::Base.logger = Logger.new(nil)
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

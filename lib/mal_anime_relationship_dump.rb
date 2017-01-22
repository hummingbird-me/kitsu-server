class MalAnimeRelationshipDump
  class DumpFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read).deep_symbolize_keys
    end

    def anime
      Mapping.lookup('myanimelist/anime', data[:id])
    end

    def create_relationship_for_mal_id(mal_kind, mal_id, role)
      media = Mapping.lookup("myanimelist/#{mal_kind}", mal_id)
      return unless media
      create_relationship_for(media, role)
    end

    def create_relationship_for(media, role)
      return unless anime
      anime.media_relationships.where(destination: media, role: role)
           .first_or_create
    end

    def apply!
      puts data[:title]
      data[:related].each do |role, role_media|
        role = role.to_s.underscore
        role_media.each do |media|
          if media.key?(:manga_id)
            create_relationship_for_mal_id(:manga, media[:manga_id], role)
          else
            create_relationship_for_mal_id(:anime, media[:anime_id], role)
          end
        end
      end
    rescue ActiveRecord::RecordNotUnique
      puts 'Uniqueness failed'
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
    Anime.connection.reconnect!
  end
end

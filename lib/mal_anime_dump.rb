MAL_DUMP_DIRECTORY = ENV['MAL_DUMP_DIRECTORY']

class MalAnimeDump
  class DumpFile
    def initialize(filename)
      @data = JSON.parse(open(filename).read).deep_symbolize_keys
    end

    def info
      {
        episode_count: data[:episodes],
        title: data[:title],
        type: data[:type]
      }
    end

    def producers
      data[:producers].map { |pro| Producer.where(name: pro).first_or_create }
    end

    def licensors
      data[:licensors].map { |pro| Producer.where(name: pro).first_or_create }
    end

    def studios
      data[:studios].map { |pro| Producer.where(name: pro).first_or_create }
    end

    def productions

      pro = anime.anime_productions.create(producer: )
    end

    def anime
      return @anime if @anime
      @anime = Mapping.lookup('myanimelist', "anime/#{mal_id}") ||
               Mapping.guess('Anime', info) ||
               Anime.new
      @anime.mappings.create(external_site: 'myanimelist',
                             external_id: "anime/#{mal_id}")
      @anime
    end

    def apply!
      anime.assign_attributes(

      )
    end
  end
  def find_anime(mal_id, info)
  end

  def load_file(mal_id)

  def update_anime(mal_id)
    anime = find_anime(mal_id, info)
  end
end

class AnidbAssocAnimeCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      # Load the JSON
      json_file = open('https://media.kitsu.io/import_files/' + filename).read
      @data = JSON.parse(json_file)
    end

    def apply!
      data.each do |unfiltered_anime|
        unfiltered_anime = unfiltered_anime.deep_symbolize_keys
        mapping_object = {
          title: unfiltered_anime[:canonical],
          episode_count: unfiltered_anime[:episode_count]
        }
        puts 'looking up -> ' + unfiltered_anime[:canonical]
        kitsu_anime = Mapping.guess('Anime', mapping_object)
        next unless kitsu_anime
        puts '      >found<'
        categories = Category.where(anidb_id: unfiltered_anime[:tags])
        kitsu_anime.categories = categories
        kitsu_anime.save
      end
    end
  end

  def run!
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    filename = 'anidb_anime_category_assoc.json'
    ImportFile.new(filename).apply!
  end
end

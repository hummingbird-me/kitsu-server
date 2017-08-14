class VolumeChapterImporter
  class ImportFile
    attr_reader :data

    def initialize(filename)
      # Load the JSON
      temp_path = File.expand_path File.dirname(__FILE__)
      json_file = File.open(temp_path + filename).read
      @data = JSON.parse(json_file)
    end

    def apply!
      kitsu_manga_cache = {}
      data.each do |viz_volume|
        viz_volume = viz_volume.deep_symbolize_keys
        # need to find the manga that corresponds to the series
        kitsu_manga = if kitsu_manga_cache.key?(viz_volume[:series])
                        kitsu_manga_cache[viz_volume[:series]]
                      else
                        Mapping.guess(
                          'Manga',
                          title: viz_volume[:series]
                        )
                      end
        next unless kitsu_manga
        kitsu_manga_cache[viz_volume[:series]] = kitsu_manga
        # need to create the volume and add it into the mapping
        # need to iterate over the chapters and compare them to kitsu chapers for manga,
        # if chapter is found then save mapping to chapter and create reference to volume on chapter
      end
    end
  end

  def run!
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    ['kitsu1.json', 'kitsu2.json'].each do |filename|
      ImportFile.new(filename).apply!
    end
  end
end

class VolumeChapterImporter
  class ImportFiles
    attr_reader :data

    def initialize(filename)
      # Load the JSON
      temp_path = File.expand_path File.dirname(__FILE__)
      json_file = File.open(temp_path + filename).read
      @data = JSON.parse(json_file)
    end

    def create_and_map_manga_with_volume(kitsu_manga, viz_volume)
      # need to create the volume and add it into the mapping
      kitsu_volume = Volume.where(
        isbn: viz_volume[:isbn],
        title: viz_volume[:series],
        manga: kitsu_manga
      ).first_or_create
      kitsu_volume.mappings.where(
        external_site: 'viz',
        external_id: viz_volume[:isbn]
      ).first_or_create
      kitsu_volume
    end

    def update_chapters_and_volume_assoc(kitsu_manga, viz_volume, kitsu_volume)
      viz_volume_number = viz_volume[:title].split(/\D/).reject(&:empty?).map(&:to_i)

      # need to some how extract chapter numbers from viz data
      chapter_title = viz_volume[:chapters].each_with_object({}) do |chapter, output|
        chapter_ids = chapter[:name].split(/\D/).reject(&:empty?).map(&:to_i)
        next if chapter_ids.empty?
        next if output.key?(chapter_ids[0])
        output[chapter_ids[0]] = chapter[:name]
      end

      # create reference to volume on chapter
      kitsu_manga.chapters.each do |c|
        next unless chapter_title.key?(c.number)
        c.volume = kitsu_volume
        c.titles = { en_jp: chapter_title[c.number] } if c.titles[:en_jp] == "Chapter #{c.number}"
        c.volume_number = viz_volume_number[-1] unless viz_volume_number.empty?
        c.save!
      end
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
        kitsu_volume = create_and_map_manga_with_volume(kitsu_manga, viz_volume)
        update_chapters_and_volume_assoc(kitsu_manga, viz_volume, kitsu_volume)
      end
    end
  end

  def run!
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    ['/kitsu1.json', '/kitsu2.json'].each do |filename|
      ImportFiles.new(filename).apply!
    end
  end
end

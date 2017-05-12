class AnidbCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read)
    end

    def apply!
      data.each do |unfiltered_category|
        unfiltered_category = unfiltered_category.deep_symbolize_keys
        puts unfiltered_category[:titles][:canonical]

        category ||= Category.find_by(anidb_id: unfiltered_category[:id]) || Category.new
        category.canonical_title ||= unfiltered_category[:titles][:canonical]
        category.description ||= unfiltered_category[:description]
        category.image_file_name ||= unfiltered_category[:image]
        category.titles ||= unfiltered_category[:titles]
        category.anidb_id ||= unfiltered_category[:id]
        category.save
      end
    end
  end

  def run!
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    filename = File.join(
      File.expand_path(
        File.dirname(__FILE__)
      ),
      'anidb_category.json'
    )
    ImportFile.new(filename).apply! if File.file?(filename)
  end
end

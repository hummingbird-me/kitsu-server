class AnidbCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read)
    end

    def apply!
      data.each do |item|
        item = item.deep_symbolize_keys
        puts item[:titles][:canonical]

        category ||= Category.find_by(anidb_id: item[:id]) || Category.new
        category.canonical_title ||= item[:titles][:canonical]
        category.description ||= item[:description]
        category.image_file_name ||= item[:image]
        category.titles ||= item[:titles]
        category.anidb_id ||= item[:id]
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

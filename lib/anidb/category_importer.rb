class AnidbCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read)
    end

    def apply!
      data.each do |_category|
        _category = _category.deep_symbolize_keys
        puts _category[:titles][:canonical]

        category ||= Category.find_by(anidb_id: _category[:id]) || Category.new
        category.canonical_title ||= _category[:titles][:canonical]
        category.description ||= _category[:description]
        category.image_file_name ||= _category[:image]
        category.titles ||= _category[:titles]
        category.anidb_id ||= _category[:id]
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

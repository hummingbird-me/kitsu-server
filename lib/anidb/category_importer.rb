class AnidbCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      @data = JSON.parse(open(filename).read)
    end

    def apply!
      data.each do |tmp_category|
        c = c.deep_symbolize_keys
        puts c[:titles][:canonical]

        category ||= Category.find_by(anidb_id: tmp_category[:id]) || Category.new
        category.canonical_title ||= tmp_category[:titles][:canonical]
        category.description ||= tmp_category[:description]
        category.image_file_name ||= tmp_category[:image]
        category.titles ||= tmp_category[:titles]
        category.anidb_id ||= tmp_category[:id]
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

class AnidbCategoryImport
  class ImportFile
    attr_reader :data

    def initialize(filename)
      # Load the JSON
      json_file = open('https://media.kitsu.io/import_files/' + filename).read
      @data = JSON.parse(json_file)
    end

    def apply!
      data.each do |item|
        item = item.deep_symbolize_keys
        puts item[:titles][:canonical].titleize

        category ||= Category.find_by(anidb_id: item[:id]) || Category.new
        category.title ||= item[:titles][:canonical].titleize
        category.description ||= item[:description]
        category.image ||= item[:image]
        category.anidb_id ||= item[:id]
        category.save
      end

      data.each do |item|
        item = item.deep_symbolize_keys
        next unless item[:parent]
        category = Category.find_by(anidb_id: item[:id])
        category.parent ||= Category.find_by(anidb_id: item[:parent])
        category.save
      end
    end
  end

  def run!
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)
    filename = 'anidb_category.json'
    ImportFile.new(filename).apply!
  end
end

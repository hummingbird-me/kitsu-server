class CategoryImporter
  class ImportFile
    attr_reader :data

    def initialize(base_media_url, filename)
      # Load the JSON
      utc = Time.now.to_i.to_s
      json_file = open(base_media_url + filename + '?' + utc).read
      @data = JSON.parse(json_file)
    end

    def apply!
      data.each do |item|
        item = item.deep_symbolize_keys
        puts item[:titles][:canonical].titleize

        category ||= Category.find_by(anidb_id: item[:id]) || Category.new
        category.title ||= item[:titles][:canonical].titleize
        category.description ||= item[:description]
        category.image = item[:image] if category.image.blank?
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
    base_media_url = 'https://media.kitsu.io/import_files/'
    filename = 'anidb_category.json'
    ImportFile.new(base_media_url, filename).apply!
  end
end

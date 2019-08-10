class MangadexImport
  attr_reader :file_location

  # ideally pass in location here?
  def initialize
    @file_location = 'tmp/mangadex_import/manga-batch-1-temp.ndjson'
  end

  def import!
    each_mangadex_entry do |data, name, mal_id|
      puts name

      kitsu_id = kitsu_id_by_mal_id(mal_id) if mal_id.present?
      kitsu_id = kitsu_id_by_name(name) if kitsu_id.blank?

      row = Row.new(kitsu_data(kitsu_id), data)
      row.create_or_update



    end
  end

  def each_mangadex_entry
    File.foreach(file_location) do |line|
      line = JSON.parse(line)
      name = line['title']['name']
      mal_id = formatted_mal_id(line.dig('external_links', 'MyAnimeList'))

      yield line, name, mal_id
    end
  end

  def formatted_mal_id(url)
    return nil if url.blank?

    url.split('/').last
  end

  private

  def kitsu_id_by_mal_id(mal_id)
    Mapping.where(
      external_site: 'myanimelist/manga',
      external_id: mal_id
    ).first
  end

  def kitsu_id_by_name(name)
    AlgoliaMediaIndex.search(
      name,
      filters: 'kind:manga AND NOT subtype:novel',
      hitsPerPage: 3
    ).first.try(:id)
  end

  def kitsu_data(kitsu_id)
    Manga.find_or_initialize_by(kitsu_id)
  end
end

class MangadexImport
  attr_reader :file_location

  # ideally pass in location here?
  def initialize
    @file_location = 'tmp/mangadex_import/manga-batch-1-temp.ndjson'
  end

  def import!
    each_mangadex_entry do |data, name, mal_id|
      kitsu_id = kitsu_id_by_mal_id(mal_id) if mal_id.present?

      if kitsu_id.blank?
        kitsu_id = kitsu_id_by_name(name)
        validate_kitsu_id(kitsu_id)
      end

      puts "Kitsu Id: #{kitsu_id}"

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

  def validate_kitsu_id(kitsu_id)
    # I am not sure what to really validate this on
    # we already know subtype is correct.
  end

  private

  def kitsu_id_by_mal_id(mal_id)
    Mapping.where(
      external_site: 'myanimelist/manga',
      external_id: mal_id
    ).first&.item_id
  end

  # TODO: check what this actually returns
  def kitsu_id_by_name(name)
    Mapping.guess(
      'manga',
      title: name,
      subtype: 'NOT subtype:novel'
    )
  end

  def kitsu_data(kitsu_id)
    Manga.where(id: kitsu_id).first_or_initialize
  end
end

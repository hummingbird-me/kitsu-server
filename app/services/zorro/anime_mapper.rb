module Zorro
  class AnimeMapper
    SELECTED_FIELDS = %w[myAnimeListID traktID anilistID tvdbID hashtags].map { |k|
      [k, true]
    }.to_h.freeze

    def run!
      each_anime do |kitsu_id, anime|
        # Import Anime Mappings
        create_mapping('aozora', anime['_id'], kitsu_id)
        mal_id = anime['myAnimeListID']
        create_mapping('myanimelist/anime', mal_id, kitsu_id) if mal_id
        create_mapping('trakt', anime['traktID'], kitsu_id) if anime['traktID']
        create_mapping('anilist', "anime/#{anime['anilistID']}", kitsu_id) if anime['anilistID']
        create_mapping('thetvdb/series', anime['tvdbID'], kitsu_id) if anime['tvdbID']
        # Import Hashtags
        hashtags.each do |tag|
          Hashtag.find_or_create(tag, item_type: 'Anime', item_id: kitsu_id)
        end
      end
    end

    private

    def each_anime
      results = { imported: 0, mapped: 0 }

      Zorro::DB::Anime.find({
        myAnimeListID: { '$exists' => true }
      }, projection: SELECTED_FIELDS).each do |anime|
        kitsu_id = Mapping.lookup('myanimelist/anime', anime['myAnimeListID'])&.id

        # Log the issue
        unless kitsu_id
          results[:imported] += 1
          kitsu_id = import_anime(anime['_id']).id
        end

        # Log the mapping
        imported_sites = anime.keys.select { |k| k.end_with?('ID') }.map { |k| k.sub(/ID\z/, '') }
        puts "#{anime['_id']} => #{kitsu_id} (+ #{imported_sites.join(', ')})"
        results[:mapped] += 1

        yield kitsu_id, anime
      end

      puts "Imported to Kitsu: #{results[:imported]} | Mapped to Aozora: #{results[:mapped]}"
    end

    def create_mapping(site, id, anime_id)
      Mapping.where(
        external_site: site,
        item_id: anime_id,
        item_type: 'Anime'
      ).first_or_create(external_id: id)
    end

    def import_anime(aozora_id)
      Zorro::AnimeImporter.new(aozora_id).run!
    end
  end
end

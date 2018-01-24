require_dependency 'with_progress_bar'

module Zorro
  # Sets up Mapping data for Aozora, imports hashtags, and potentially creates new anime where we
  # don't already have them.
  class AnimeMapper
    include WithProgressBar

    SELECTED_FIELDS = %w[myAnimeListID traktID anilistID tvdbID hashtags].map { |k|
      [k, true]
    }.to_h.freeze

    class << self
      def run!
        each_anime do |kitsu_id, anime|
          # Import Anime Mappings
          create_mapping('aozora', anime['_id'], kitsu_id)
          mal_id = anime['myAnimeListID']
          create_mapping('myanimelist/anime', mal_id, kitsu_id) if mal_id
          create_mapping('trakt', anime['traktID'], kitsu_id) if anime['traktID']
          create_mapping('anilist', "anime/#{anime['anilistID']}", kitsu_id) if anime['anilistID']
          create_mapping('thetvdb', anime['tvdbID'], kitsu_id) if anime['tvdbID']
          # Import Hashtags
          anime['hashtags'].each do |tag|
            Hashtag.find_or_create(tag, item_type: 'Anime', item_id: kitsu_id)
          end
        end
      end

      private

      # Runs a block for each anime in the Aozora database, ignoring items without a myAnimeListID,
      # picking only the necessary columns, matching them to Kitsu, and then logging them.
      #
      # Probably does too much, frankly, but that's okay.  This code is gonna get deleted once it's
      # been run once.
      def each_anime # rubocop:disable Metrics/AbcSize
        # Build our filter
        filter = { myAnimeListID: { '$exists' => true } }
        # Set up a hash to track our actions for logging purposes
        results = { imported: 0, mapped: 0 }
        # Set up a progress bar
        bar = progress_bar('Aozora', Zorro::DB::Anime.count(filter))

        # Find all the anime with MAL IDs, pick the fields with the projection param, and iterate
        Zorro::DB::Anime.find(filter, projection: SELECTED_FIELDS).each do |anime|
          # Find the kitsu_id using the MAL ID from Aozora
          kitsu_id = Mapping.lookup('myanimelist/anime', anime['myAnimeListID'])&.id

          # If we don't have a match, import it and note that in the results hash
          unless kitsu_id
            kitsu_id = import_anime(anime['_id']).id
            results[:imported] += 1
          end

          # Log the mappings that Aozora has and log that we successfully mapped it
          # First, grab all the keys and strip them of the "ID" suffix
          imported_sites = anime.keys.select { |k| k.end_with?('ID') }.map { |k| k.sub(/ID\z/, '') }
          # Then log the Aozora ID, the Kitsu ID, and the names of other sites we're getting IDs for
          puts "#{anime['_id']} => #{kitsu_id} (+ #{imported_sites.join(', ')})"
          # Yes, we increment this too, it's technically a superset of imported items.
          results[:mapped] += 1
          # Push the bar forward
          bar.increment

          yield kitsu_id, anime
        end

        puts "Imported to Kitsu: #{results[:imported]} | Mapped to Aozora: #{results[:mapped]}"
      end

      # Creates a mapping if it doesn't already exist in the database
      #
      # @param site [String] the external_site key for the Mapping table
      # @param id [String] the external_id value for the Mapping table
      # @param anime_id [Integer] the Kitsu ID of the Anime
      def create_mapping(site, id, anime_id)
        Mapping.where(
          external_site: site,
          item_id: anime_id,
          item_type: 'Anime'
        ).first_or_create(external_id: id)
      end

      # Imports an anime from Aozora
      #
      # @param aozora_id [String] the Anime ID in the Aozora database
      def import_anime(aozora_id)
        Zorro::Importer::AnimeImporter.new(aozora_id).run!
      end
    end
  end
end

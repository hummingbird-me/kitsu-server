require_dependency 'with_progress_bar'

module Zorro
  module Importer
    # Imports favorites from Aozora to Kitsu
    class FavoritesImporter
      include WithProgressBar

      # Import all follows into Kitsu
      def self.run!
        bar = progress_bar('Favorites', follows_by_user)
        follows_by_user.each do |follow|
          new(follow).run!
          bar.increment
        end
        bar.finish
      end

      # @param user [User] the user to import faves for
      def self.for_user(user)
        new(_p_user: "_User$#{user.ao_id}")
      end

      # @param filter [Hash] the MongoDB filter to use
      def initialize(user)
        @user = user
        @faves = Zorro::DB::AnimeProgress.find(
          {
            isFavorite: true,
            _p_user: "_User$#{user.ao_id}"
          }
        ).projection(_p_anime: 1, _id: false)
      end

      def count
        @faves.count
      end

      # Saves the faves into the Kitsu database
      def run!
        aozora_ids = @faves.map { |fave| fave['_p_anime'].split('$').first }
        anime_ids = Mapping.where(
          external_site: 'aozora',
          external_id: aozora_ids,
          item_type: 'Anime'
        ).pluck(:item_id)

        rows = anime_ids.with_index.map do |id, index|
          [@user.id, index * 500, 'Anime', id, time, time]
        end

        Favorite.import %w[user_id fav_rank item_type item_id created_at updated_at], rows
      end
    end
  end
end

module Zorro
  module Importer
    # Imports an anime from Aozora to Kitsu.  Useful if we don't already have it in our database
    class AnimeImporter
      delegate :assoc, to: Zorro::DB

      # @param aozora_id [String] the ID of the anime in the Aozora database to be imported
      def initialize(aozora_id)
        @aozora_id = aozora_id
      end

      # @return [Hash] the document representing the anime in Aozora
      def anime_data
        @anime ||= Zorro::DB::Anime.find(_id: @aozora_id).limit(1).first
      end

      # Details includes synopsis and synonyms
      # @return [Hash] the document representing the anime details in Aozora
      def details
        @details ||= assoc(anime_data['_p_details'])
      end

      # @return [Symbol] the symbol for the subtype in Kitsu
      def subtype
        case anime_data['type']
        when 'OVA', 'ONA', 'TV' then anime_data['type'].to_sym
        else anime_data['type'].underscore.to_sym
        end
      end

      # @return [Hash] the titles hash as used by Kitsu
      def titles
        {
          en_jp: anime_data['title'],
          en_us: details['englishTitles']&.first,
          ja_jp: details['japaneseTitles']&.first
        }.compact
      end

      # @return [Integer,nil] the number of episodes
      def episode_count
        anime_data['episodes']&.positive? ? anime_data['episodes'] : nil
      end

      # @return [Integer,nil] the episode length in minutes
      def episode_length
        anime_data['duration']&.positive? ? anime_data['duration'] : nil
      end

      # Create the Anime in the Kitsu database
      #
      # @return [Anime] the anime that was created
      def run!
        Anime.create!(
          titles: titles,
          abbreviated_titles: details['synonyms'],
          subtype: subtype,
          synopsis: details['synopsis'],
          episode_length: episode_length,
          episode_count: episode_count,
          poster_image: canonical_for(anime_data['imageUrl']),
          start_date: anime_data['startDate'],
          end_date: anime_data['endDate']
        )
      end

      private

      # Recursively follow redirects to find the canonical URL for a file, since open-uri will throw
      # an error if it gets a redirect.  If any of the requests fail (or are a gif, lol) this
      # returns nil.
      #
      # NOTE: this code sucks, and does not prevent infinite loops, so it may blow the stack or
      # something.  But who cares, this is a one time script, so #YOLO
      #
      # @return [String, nil] the final URL, following redirects
      def canonical_for(url)
        req = Typhoeus.head(url)
        return unless req.success?
        return if req.headers['Content-Type'] == 'image/gif'
        return canonical_for(req.headers['Location']) if req.headers['Location']
        url
      end
    end
  end
end

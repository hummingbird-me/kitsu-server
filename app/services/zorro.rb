module Zorro
  # Connect to MongoDB if configured
  if ENV['AOZORA_MONGO_URL'].present?
    Client = Mongo::Client.new(ENV['AOZORA_MONGO_URL'], max_pool_size: 24)
  end

  Cache = LookupCache.new

  module DB
    # Create shortcuts to various useful collections if we're connected
    if ENV['AOZORA_MONGO_URL'].present?
      # Profiles
      User = Client['_User'] # Parse prefixes the User collection with an underscore
      UserDetails = Client['UserDetails']
      # Follows (which have a strange collection name in Mongo cause of Parse)
      Follow = Client['_Join:following:_User']
      # Media
      Anime = Client['Anime']
      # Community
      Post = Client['Post']
      TimelinePost = Client['TimelinePost']
      Thread = Client['Thread']
      POST_COLLECTIONS = [TimelinePost, Thread, Post].freeze
      # Library
      AnimeProgress = Client['AnimeProgress']
    end

    # Process a Parse pointer and load the document it refers to
    #
    # @overload assoc(ref)
    #   @param ref [String, Hash] a reference to a document
    #   @return [Hash] the data in the referenced document
    #   @example With a String-based reference
    #     assoc("User$1d2c3b4a") #=> { "_id": "1d2c3b4a", ... }
    #   @example With a Hash-based reference
    #     assoc(
    #       '__type' => 'Pointer',
    #       'className' => 'User',
    #       'objectId' => '1d2c3b4a'
    #     )
    #     #=> { "_id": "1d2c3b4a", ... }
    # @overload assoc(ref)
    #   @param ref [Array<Hash,String>] a list of references to document
    #   @return [Array<Hash>] the data in the referenced documents
    def self.assoc(ref)
      case ref
      when String
        collection, id = ref.split('$')
        Zorro::Client[collection].find(_id: id).limit(1).first
      when Hash
        collection, id = ref.values_at('className', 'objectId')
        Zorro::Client[collection].find(_id: id).limit(1).first
      when Array
        ref.map { |r| assoc(r) }
      end
    end
  end
end

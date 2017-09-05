module Zorro
  Client = Mongo::Client.new(ENV['AOZORA_MONGO_URL']) if ENV['AOZORA_MONGO_URL'].present?

  module DB
    if ENV['AOZORA_MONGO_URL'].present?
      # Shortcuts to various collections
      User = Client['_User']
      UserDetails = Client['UserDetails']
      Anime = Client['Anime']
      Post = Client['Post']
      TimelinePost = Client['TimelinePost']
      Thread = Client['Thread']
      AnimeProgress = Client['AnimeProgress']
    end

    def self.assoc(assoc)
      case assoc
      when String
        collection, id = assoc.split('$')
        Zorro::Client[collection].find(_id: id).limit(1).first
      when Hash
        collection, id = assoc.values_at('className', 'objectId')
        Zorro::Client[collection].find(_id: id).limit(1).first
      end
    end
  end
end

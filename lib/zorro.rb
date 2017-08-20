module Zorro
  Client = Mongo::Client.new(ENV['AOZORA_MONGO_URL'])

  module DB
    # Shortcuts to various collections
    User = Client['_User']
    UserDetails = Client['UserDetails']
    Anime = Client['Anime']
    Post = Client['Post']
    TimelinePost = Client['TimelinePost']
    Thread = Client['Thread']
    AnimeProgress = Client['AnimeProgress']
  end
end

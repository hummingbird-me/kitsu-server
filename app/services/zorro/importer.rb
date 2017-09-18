module Zorro
  module Importer
    def self.run!
      # Import Aozora Anime Mappings & Hashtag data
      AnimeMapper.run!
      # Create the Aozora groups
      Groups.create!
      # Import the users
      UserImporter.run!
      # Import posts, threads, and other feed content
      PostsImporter.run!
      # Import likes
      LikesImporter.run!
    end
  end
end

class Types::Anime < Types::BaseObject
  implements Types::Interface::Media
  implements Types::Interface::Episodic
  implements Types::Interface::WithTimestamps

  field :subtype, Types::Enum::AnimeSubtype,
    null: false,
    description: 'A secondary type for categorizing Anime.'

  field :youtube_trailer_video_id,
    String,
    null: true,
    method: :youtube_video_id,
    description: 'Video id for a trailer on YouTube'

  field :streaming_links, Types::StreamingLink.connection_type,
    null: false,
    description: 'The stream links.'

  def streaming_links
    AssociationLoader.for(object.class, :streaming_links).scope(object)
  end

  field :feed, Types::Feed,
    null: false,
    description: ''

  def feed
    AnimeFeed.new(object.id)
  end
end

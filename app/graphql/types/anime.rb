class Types::Anime < Types::BaseObject
  implements Types::Interface::Media
  implements Types::EpisodicInterface

  field :subtype, Types::Enum::AnimeSubtype,
    null: false,
    description: 'A secondary type for categorizing Anime.'

  field :youtube_trailer_video_id,
    String,
    null: true,
    method: :youtube_video_id,
    description: 'Video id for a trailer on YouTube'
end

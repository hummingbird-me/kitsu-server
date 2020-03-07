class Types::Anime < Types::BaseObject
  implements Types::Media
  implements Types::EpisodicInterface

  field :youtube_video_id, String,
    null: true,
    description: 'Video id for a trailer on YouTube'
end

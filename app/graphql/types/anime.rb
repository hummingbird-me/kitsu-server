class Types::Anime < Types::BaseObject
  implements Types::Media
  implements Types::EpisodicInterface

  field :youtube_trailer_video_id, String,
    null: true,
    method: :youtube_video_id,
    description: 'Video id for a trailer on YouTube'
end

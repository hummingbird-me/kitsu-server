class Types::Streamer < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'The streaming company.'

  field :id, ID, null: false

  field :site_name, String,
    null: false,
    description: 'The name of the site that is streaming this media.'

  field :streaming_links, Types::StreamingLink.connection_type,
    null: false,
    description: 'Additional media this site is streaming.'

  def streaming_links
    AssociationLoader.for(object.class, :streaming_links).scope(object)
  end

  field :videos, Types::Video.connection_type,
    null: false,
    description: 'Videos of the media being streamed.'

  def videos
    AssociationLoader.for(object.class, :videos).scope(object)
  end
end

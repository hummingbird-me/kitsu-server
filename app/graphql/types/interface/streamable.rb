module Types::Interface::Streamable
  include Types::Interface::Base
  description 'Media that is streamable'

  field :streaming_links, Types::StreamingLink.connection_type,
    null: false,
    description: ''

  def streaming_links
    AssociationLoader.for(object.class, :streaming_links).scope(object)
  end
end

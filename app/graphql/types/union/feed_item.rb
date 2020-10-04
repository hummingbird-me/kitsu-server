class Types::Union::FeedItem < Types::Union::Base
  connection_type_class(Types::FeedConnection)
  description 'Objects which are part of a Feed'

  possible_types Types::Post, Types::Profile
end

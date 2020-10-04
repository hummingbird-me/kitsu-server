class Types::Union::FeedItem < Types::Union::Base
  description 'Objects which are part of a Feed'

  possible_types Types::Post, Types::Profile
end

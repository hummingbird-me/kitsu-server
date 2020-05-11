class Types::Post < Types::BaseObject
  description 'A post'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'The user who created this post.'

  field :media, Types::Media,
    null: true,
    description: 'The media tagged in this post.'

  field :spoiler, Boolean,
    null: false,
    description: 'If this post spoils a media.'

  field :nsfw, Boolean,
    null: false,
    description: 'If a post is Not-Safe-for-Work.'
end

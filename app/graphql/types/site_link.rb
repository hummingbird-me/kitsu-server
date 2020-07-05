class Types::SiteLink < Types::BaseObject
  description 'A link to an external site related to a specific user profile'

  field :id, ID, null: false

  field :url, String,
    null: false,
    description: 'The full url for the site, including the user profile.'

  field :author, Types::Profile,
    null: false,
    description: 'The user profile the site is linked to.'
end

class Types::SiteLink < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description "A link to a user's profile on an external site."

  field :id, ID, null: false

  field :url, String,
    null: false,
    description: 'A fully qualified URL of the user profile on an external site.'

  field :author, Types::Profile,
    null: false,
    description: 'The user profile the site is linked to.'
end

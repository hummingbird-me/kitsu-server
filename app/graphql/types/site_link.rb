class Types::SiteLink < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description "A link to a user's profile on an external site."

  field :id, ID, null: false

  field :site, Types::ProfileLinkSite,
    null: false,
    description: 'The actual linked website.'

  def site
    Loaders::RecordLoader.for(
      ::ProfileLinkSite,
      token: context[:token]
    ).load(object.profile_link_site_id)
  end

  field :url, String,
    null: false,
    description: 'A fully qualified URL of the user profile on an external site.'

  field :author, Types::Profile,
    null: false,
    description: 'The user profile the site is linked to.'
end

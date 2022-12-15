class Mutations::ProfileLink::Update < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::ProfileLink::Update,
    required: true,
    description: 'Add a profile link',
    as: :profile_link

  field :site_link, Types::SiteLink, null: true

  def load_profile_link(value)
    profile_link = ProfileLink.find_by!(
      user_id: current_user.id,
      profile_link_site_id: value.profile_link_site_id
    )
    profile_link.assign_attributes(value.to_h)
    profile_link
  end

  def authorized?(profile_link:)
    return true if ProfileLinkPolicy.new(context[:token], profile_link).update?

    [false, {
      errors: [
        { message: 'Not Authorized', code: 'NotAuthorized' }
      ]
    }]
  end

  def resolve(profile_link:)
    profile_link.save!

    { site_link: profile_link }
  end
end

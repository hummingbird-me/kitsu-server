# frozen_string_literal: true

class Mutations::ProfileLink::Delete < Mutations::Base
  include FancyMutation

  description 'Delete a profile link'

  input do
    argument :profile_link,
      Types::Enum::ProfileLinksSites,
      required: true,
      description: 'The profile link to delete'
  end
  result Types::SiteLink
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(profile_link:)
    authenticate!
    @profile_link = ProfileLink.find_by(
      profile_link_site_id: profile_link,
      user_id: current_user.id
    )
    return errors << Types::Errors::NotFound.build if @profile_link.nil?
    authorize!(@profile_link, :destroy?)
    true
  end

  def resolve(**)
    @profile_link.destroy!
    @profile_link
  end
end

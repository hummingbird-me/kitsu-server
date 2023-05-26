# frozen_string_literal: true

class Mutations::ProfileLink::Update < Mutations::Base
  include FancyMutation

  description 'Update profile links'

  input do
    argument :url, String,
      required: true,
      description: 'The url of the profile link',
      as: :profile_link_url
    argument :profile_link_site,
      Types::Enum::ProfileLinksSites,
      required: true,
      description: 'The website.'
  end
  result Types::SiteLink
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(profile_link_site:, **)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    @profile_link = ProfileLink.find_by!(
      profile_link_site_id: profile_link_site,
      user_id: current_user.id
    )
    # return errors << Types::Errors::NotFound.build if @profile_link.nil?
    authorize!(@profile_link, :update?)
    true
  end

  def resolve(profile_link_url:, **)
    @profile_link.update!(url: profile_link_url)
    @profile_link.tap(&:save!)
  end
end

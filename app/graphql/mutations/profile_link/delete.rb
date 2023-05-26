# frozen_string_literal: true

class Mutations::ProfileLink::Delete < Mutations::Base
  include FancyMutation

  description 'Delete a profile link'

  input do
    argument :profile_link_id, ID,
      required: true,
      description: 'The profile link to delete'
  end
  result Types::SiteLink
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(profile_link_id:)
    authenticate!
    @profile_link = ProfileLink.find_by(id: profile_link_id)
    return errors << Types::Errors::NotFound.build if @profile_link.nil?
    authorize!(@profile_link, :destroy?)
    true
  end

  def resolve(**)
    @profile_link.destroy!
    @profile_link
  end
end

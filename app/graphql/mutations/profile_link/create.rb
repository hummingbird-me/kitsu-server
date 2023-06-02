# frozen_string_literal: true

class Mutations::ProfileLink::Create < Mutations::Base
  include FancyMutation

  description 'Create a profile link'

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
    Types::Errors::NotFound,
    Types::Errors::Validation

  def ready?(**)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    profile_link = ProfileLink.find_by(
      profile_link_site_id: profile_link,
      user_id: current_user.id
    )
    raise GraphQL::ExecutionError, 'You already have this profile link.' if profile_link
    true
  end

  def resolve(profile_link_url:, profile_link_site:, **)
    @profile_link = ProfileLink.new(
      url: profile_link_url,
      profile_link_site_id: profile_link_site,
      user_id: current_user.id
    )
    authorize!(@profile_link, :create?)
    @profile_link.tap(&:save!)
  rescue ActiveRecord::RecordInvalid => e
    errors.push(*Types::Errors::Validation.for_record(e.record, prefix: 'input'))
  end
end

# frozen_string_literal: true

class Mutations::Account::Update < Mutations::Base
  include FancyMutation

  description 'Update account'

  input do
    argument :sfw_filter_preference,
      Types::Enum::SfwFilterPreference,
      required: false,
      description: 'The SFW Filter setting'
    argument :country,
      String,
      required: false,
      description: 'The country of the user'
    argument :site_theme,
      Types::Enum::SiteTheme,
      required: false,
      description: 'The theme displayed on Kitsu'
    argument :rating_system,
      Types::Enum::RatingSystem,
      required: false,
      description: 'The preferred rating system'
    argument :preferred_title_language,
      Types::Enum::TitleLanguagePreference,
      required: false,
      description: 'How media titles will get visualized'
    argument :time_zone,
      String,
      required: false,
      description: 'The time zone of the user'
  end
  result Types::Account
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(**)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    authorize!(current_user, :update?)
    true
  end

  def resolve(**input)
    current_user.update!(**input)
    current_user
  end
end

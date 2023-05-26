# frozen_string_literal: true

class Mutations::Profile::Update < Mutations::Base
  include FancyMutation

  description 'Update profile'

  input do
    argument :id, ID,
      required: true,
      description: 'Your ID or the one of another user.'
    argument :about, String,
      required: false,
      description: 'About section of the profile.'
    argument :waifu_or_husbando,
      Types::Enum::WaifuOrHusbando,
      required: false,
      description: 'The user preference of their partner.'
    argument :waifu_id, ID,
      required: false,
      description: 'The id of the waifu or husbando.'
    argument :gender, String,
      required: false,
      description: 'The preferred gender of the user.'
    argument :birthday, Types::Date,
      required: false,
      description: 'The birthday of the user.'
  end
  result Types::Profile
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotAuthorized,
    Types::Errors::NotFound

  def ready?(id:, **)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    @profile = ::User.find(id)
    return errors << Types::Errors::NotFound.build if @profile.nil?
    authorize!(@profile, :update?)
    true
  end

  def resolve(**input)
    @profile.update!(**input)
    @profile.tap(&:save!)
  end
end

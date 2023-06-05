# frozen_string_literal: true

class Mutations::Profile::Update < Mutations::Base
  include FancyMutation

  description 'Update profile'

  input do
    argument :id, ID,
      required: false,
      description: 'Your ID or the one of another user.'
    argument :name,
      String,
      required: false,
      description: 'The display name of the user'
    argument :slug,
      String,
      required: false,
      description: 'The slug (@username) of the user'
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

  def ready?(**input)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    @profile = if input[:id]
      ::User.find_by(id: input[:id])
    else
      current_user
    end
    return errors << Types::Errors::NotFound.build if @profile.nil?
    authorize!(@profile, :update?)
    true
  end

  def resolve(**input)
    @profile.update!(**input)
    @profile.tap(&:save!)
  end
end

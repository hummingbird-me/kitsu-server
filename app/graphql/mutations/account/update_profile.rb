class Mutations::Account::UpdateProfile < Mutations::Base
  prepend RescueValidationErrors

  description 'Update profile'

  argument :input,
    Types::Input::Account::UpdateProfile,
    required: true,
    description: 'Update profile',
    as: :profile

  field :profile, Types::Profile, null: true

  def load_profile(value)
    if current_token.blank?
      raise GraphQL::ExecutionError, 'You must be authorized to edit profile settings.'
    else
      profile = ::User.find(current_user.id)
      profile.assign_attributes(value.to_h)
      profile
    end
  end

  def resolve(profile:)
    profile.save!

    { profile: profile }
  end
end
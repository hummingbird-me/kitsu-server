class Mutations::Account::UpdateProfile < Mutations::Base
  prepend RescueValidationErrors

  description 'Update profile'

  argument :input,
    Types::Input::Account::UpdateProfile,
    required: true,
    description: 'Update profile',
    as: :profile

  field :profile, Types::Profile, null: true

  def ready?(profile:)
    if current_token.blank?
      raise GraphQL::ExecutionError, 'You must be authorized.'
    end
    true
  end

  def load_profile(value)
    userid = value.id
    if userid.nil?
      userid = current_user.id
    end
    profile = ::User.find(userid)
    profile.assign_attributes(value.to_h)
    profile
  end

  def authorized?(profile:)
    if current_user.admin? || profile.id == current_user.id
      return true
    end
    raise GraphQL::ExecutionError, 'You must be a moderator to edit someone else profile.'
  end

  def resolve(profile:)
    profile.save!

    { profile: profile }
  end
end
class Mutations::Profile::Update < Mutations::Base
  prepend RescueValidationErrors

  description 'Update profile'

  argument :input,
    Types::Input::Profile::Update,
    required: true,
    description: 'Update profile',
    as: :profile

  field :profile, Types::Profile, null: true

  def ready?(profile:)
    raise GraphQL::ExecutionError, 'You must be authorized.' if current_token.blank?
    true
  end

  def load_profile(value)
    userid = value.id
    userid = current_user.id if userid.nil?
    profile = ::User.find(userid)
    profile.assign_attributes(value.to_h)
    profile
  end

  def authorized?(profile:)
    return true if current_user.admin? || profile.id == current_user.id
    raise GraphQL::ExecutionError, 'You must be authorized to edit someone else profile.'
  end

  def resolve(profile:)
    profile.save!

    { profile: profile }
  end
end

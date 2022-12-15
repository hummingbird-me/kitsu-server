class Mutations::Account::Update < Mutations::Base
  prepend RescueValidationErrors

  description 'Update profile and account'

  argument :input,
    Types::Input::Account::Update,
    required: true,
    description: 'Update profile and account',
    as: :profile

  field :profile, Types::Profile, null: true
  field :account, Types::Account, null: true

  def ready?(profile:)
    if current_token.blank?
      raise GraphQL::ExecutionError, 'You must be authorized to edit account settings.'
    end
    true
  end

  def load_profile(value)
    profile = ::User.find(current_user.id)
    profile.assign_attributes(value.to_h)
    profile
  end

  def resolve(profile:)
    profile.save!

    { profile: profile, account: profile }
  end
end

# frozen_string_literal: true

class Mutations::Account::ChangePassword < Mutations::Base
  include PublicMutation
  include RateLimitedMutation
  include FancyMutation

  description 'Change your Kitsu account password'

  input do
    argument :old_password, String,
      required: true,
      description: 'The current, existing password for the account'

    argument :new_password, String,
      required: true,
      description: 'The new password to set'
  end
  result Types::Account
  errors Types::Errors::NotAuthorized,
    Types::Errors::NotAuthenticated,
    Types::Errors::Validation

  def ready?(old_password:, **)
    authenticate!

    return true if current_user&.authenticate(old_password)

    errors << Types::Errors::NotAuthorized.build(
      message: I18n.t('graphql.errors.password_incorrect')
    )
  end

  def resolve(new_password:, **)
    current_user.update!(password: new_password)
    current_user
  rescue ActiveRecord::RecordInvalid => e
    errors.push(*Types::Errors::Validation.for_record(e.record, prefix: 'input'))
  end
end

# frozen_string_literal: true

class Types::Errors::NotAuthorized < Types::Errors::Base
  description <<-DESC.squish
    The mutation requires higher permissions than the current user or token has. This is a bit
    vague, but it generally means you're attempting to modify an object you don't own, or perform
    an administrator action without being an administrator. It could also mean your token does not
    have the required scopes to perform the action. The recommended action is to display a message
    to the user informing them that their action failed and that retrying will generally *not* help.
  DESC

  field :action, String, null: true
end

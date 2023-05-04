# frozen_string_literal: true

class Types::Errors::NotFound < Types::Errors::Base
  description <<-DESC.squish
    An object required for your mutation was unable to be located. Usually this means the object
    you're attempting to modify or delete does not exist. The recommended action is to display a
    message to the user informing them that their action failed and that retrying will generally
    *not* help.
  DESC
end

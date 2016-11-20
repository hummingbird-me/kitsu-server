module DoorkeeperHelpers
  extend ActiveSupport::Concern

  # Returns the current user
  alias_method :current_user, :doorkeeper_token

  # Return boolean representing whether there is a user signed in
  def signed_in?
    current_user.present?
  end

  # Provide context of current user to JR
  def context
    { current_user: doorkeeper_token }
  end
end

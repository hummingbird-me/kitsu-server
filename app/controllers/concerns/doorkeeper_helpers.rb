module DoorkeeperHelpers
  extend ActiveSupport::Concern

  def current_user
    doorkeeper_token
  end

  # Return boolean representing whether there is a user signed in
  def signed_in?
    current_user.present?
  end

  # Provide context of current user to JR
  def context
    { current_user: current_user }
  end
end

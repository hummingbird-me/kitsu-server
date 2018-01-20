module DoorkeeperHelpers
  extend ActiveSupport::Concern

  included do
    around_action :store_user_on_thread
  end

  def store_user_on_thread
    Thread.current[:current_user] = doorkeeper_token&.resource_owner
    begin
      yield
    ensure
      Thread.current[:current_user] = nil
    end
  end

  def current_user
    doorkeeper_token
  end

  # Return boolean representing whether there is a user signed in
  def signed_in?
    current_user.present?
  end

  # Validate token
  def validate_token!
    # If we have a token, but it's not valid, explode
    if doorkeeper_token && !doorkeeper_token.accessible?
      render json: {
        errors: [
          { title: 'Invalid token', status: '403' }
        ]
      }, status: 403
    end
  end

  # Provide context of current user to JR
  def context
    { current_user: current_user }
  end
end

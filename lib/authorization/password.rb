module Authorization
  class Password
    def initialize(auth, password)
      @auth = auth
      @password = password
    end

    # @return [User, nil] the user who has been authenticated
    def user!
      user if user&.authenticate(@password)
    end

    def user
      if Flipper.enabled?(:aozora)
        conflict.user!
      else
        kitsu_user
      end
    end

    private

    def kitsu_user
      @kitsu_user ||= User.find_for_auth(@auth)
    end

    # The UserConflictDetector instance
    def conflict
      @conflict ||= Zorro::UserConflictDetector.new(email: email)
    end

    # If they log in with a username, we need to get their email to handle conflicts.
    # @return [String] the email address to find accounts for
    def email
      @auth.include?('@') ? @auth : kitsu_user&.email
    end
  end
end

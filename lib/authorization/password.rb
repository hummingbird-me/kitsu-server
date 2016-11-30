module Authorization
  class Password
    def initialize(username, password)
      @user = User.find_for_auth(username)
      @password = password
    end

    def user!
      @user if @user&.authenticate(@password)
    end
  end
end

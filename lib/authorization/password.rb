module Authorization
  class Password
    def initialize(username, password)
      @user = User.find_for_auth(username)
      @password = password
    end

    def user!
      @user if @user&.authenticate(@password) && allowed?
    end

    def allowed?
      return true
      if Rails.env.staging?
        @user.pro? || @user.has_role?(:admin) || @user.has_role?(:client_dev)
      else
        true
      end
    end
  end
end

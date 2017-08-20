module Zorro
  class UserMatcher
    def initialize(user)
      @user = user
    end

    def target_user
      case conflict_resolution
      when :merge then email_user
      when :rename, nil then ::User.new(name: target_username)
      end
    end

    def target_username
      if conflict_resolution == :rename
        "aozora_#{@user['aozoraUsername']}"
      else
        @user['aozoraUsername']
      end
    end

    def conflict
      return :email if email_conflict?
      return :name if name_conflict?
    end

    def conflict_resolution
      return :merge if email_conflict?
      return :rename if name_conflict?
    end

    private

    def email_user
      @email_user ||= ::User.by_email(email).first
    end

    def email_conflict?
      email_user.present?
    end

    def name_user
      @name_user ||= ::User.by_name(username).first
    end

    def name_conflict?
      name_user.present?
    end

    def username
      @user['aozoraUsername']
    end

    def email
      @user['email']
    end
  end
end

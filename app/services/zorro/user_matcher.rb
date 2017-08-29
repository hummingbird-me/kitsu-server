module Zorro
  class UserMatcher
    attr_reader :user

    def initialize(user)
      @user = UserWrapper.new(user)
    end

    def apply!
      target_user.save!
    end

    def target_user
      case conflict_resolution
      when :merge then email_user
      when :rename, nil
        User.new.tap do |user|
          @user.new.merge_onto(user)
          user.name = target_username
        end
      end
    end

    def target_username
      conflict_resolution == :rename ? "aozora_#{@user.name}" : @user.name
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
      @email_user ||= User.by_email(@user.email).first
    end

    def email_conflict?
      email_user.present?
    end

    def name_user
      @name_user ||= User.by_name(@user.name).first
    end

    def name_conflict?
      name_user.present?
    end
  end
end

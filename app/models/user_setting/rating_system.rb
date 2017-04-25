class UserSetting < ApplicationRecord
  class RatingSystem < UserSetting
    validate do
      value.is_a?(String)
    end

    def self.create_default_for(user)
      where(user: user).first_or_initialize(value: 'simple')
    end
  end
end

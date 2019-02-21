module Pro
  class SetMessage < Action
    parameter :user, load: User, required: true
    parameter :message, required: true

    validates :message, length: { maximum: 120 }

    def call
      raise NotAuthorizedError unless can_set_message?

      user.update!(pro_message: message)
    end

    def can_set_message?
      user.patron? && user.pro_message.blank?
    end
  end
end

module Pro
  class SetDiscord < Action
    parameter :user, load: User, required: true
    parameter :discord, required: true

    validates :discord, format: {
      with: /\A.*\#\d+\z/,
      message: 'must be a proper Discord Tag (Name#1234)'
    }

    def call
      raise NotAuthorizedError unless user.patron?

      user.update!(pro_discord_user: discord)
    end
  end
end

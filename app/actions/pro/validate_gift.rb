module Pro
  class ValidateGift < Action
    parameter :from, load: User, required: true
    parameter :to, load: User, required: true
    parameter :tier, required: true
    parameter :message

    # Validates the gift and raises an exception if it's not valid
    # @raise [ActiveRecord::RecordNotFound] the recipient is not visible to the sender
    # @raise [ProError::InvalidSelfGift] attempting to send a gift to themselves
    # @raise [ProError::RecipientIsPro] the recipient is already pro and cannot receive a gift
    # @raise [ProError::InvalidTier] the tier of pro is unknown
    # @return [void]
    def call
      # If they're blocked, we raise RecordNotFound like "new phone who dis"
      raise ActiveRecord::RecordNotFound if blocked?
      raise ProError::InvalidSelfGift if from == to
      raise ProError::RecipientIsPro if to.pro?
      raise ProError::InvalidTier unless tier.in?(%w[pro patron])
    end

    private

    def blocked?
      from.blocked?(to)
    end
  end
end

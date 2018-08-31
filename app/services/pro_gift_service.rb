# Coordinates the gifting of pro to a user
class ProGiftService
  class InvalidSelfGift < StandardError; end
  class RecipientIsPro < StandardError; end

  # @param from [User] the user giving the gift
  # @param to [User] the recipient of the gift
  # @param message [String] the message to send in the email for the gift
  def initialize(from:, to:, message: nil)
    @from = from
    @to = to
    @message = message
  end

  # Validates the gift and sends if it can.  Otherwise, raises an exception.
  # @raise [ActiveRecord::RecordNotFound] the recipient is not visible to the sender
  # @raise [InvalidSelfGift] attempting to send a gift to themselves
  # @raise [RecipientIsPro] the recipient of the gift is already pro and cannot receive this gift
  def call
    raise ActiveRecord::RecordNotFound if blocked?
    raise InvalidSelfGift if @from == @to
    raise RecipientIsPro if @to.pro?

    gift.save!
  end

  private

  def gift
    @gift ||= ProGift.new(
      from: @from,
      to: @to,
      message: @message
    )
  end

  def blocked?
    @from.blocked?(@to)
  end
end

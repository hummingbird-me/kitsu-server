# Coordinates the gifting of pro to a user
class ProGiftService
  class InvalidSelfGift < StandardError; end
  class RecipientIsPro < StandardError; end
  class InvalidLength < StandardError; end

  # @param from [User] the user giving the gift
  # @param to [User] the recipient of the gift
  # @param length [:month,:year] the length of the gift
  # @param message [String] the message to send in the email for the gift
  def initialize(from:, to:, length:, message: nil)
    @from = from
    @to = to
    @length = length
    @message = message
  end

  # Validates the gift and raises an exception if it's not valid
  # @raise [ActiveRecord::RecordNotFound] the recipient is not visible to the sender
  # @raise [InvalidSelfGift] attempting to send a gift to themselves
  # @raise [RecipientIsPro] the recipient of the gift is already pro and cannot receive this gift
  # @raise [InvalidLength] the length of gift is not valid
  def validate!
    raise ActiveRecord::RecordNotFound if blocked?
    raise InvalidSelfGift if @from == @to
    raise RecipientIsPro if @to.pro?
    raise InvalidLength unless %i[year month].include?(@length)
  end

  # Sends the gift
  def send
    gift.save!
  end

  delegate :to_json, to: :gift

  private

  def gift
    @gift ||= ProGift.new(
      from: @from,
      to: @to,
      length: @length,
      message: @message
    )
  end

  def blocked?
    @from.blocked?(@to)
  end
end

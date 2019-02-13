class ProError < StandardError
  class InvalidSelfGift < ProError; end
  class RecipientIsPro < ProError; end
  class InvalidTier < ProError; end
end

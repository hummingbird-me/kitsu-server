$braintree = Braintree::Gateway.new(
  environment: ENV['BRAINTREE_ENVIRONMENT'],
  merchant_id: ENV['BRAINTREE_MERCHANT_ID'],
  public_key: ENV['BRAINTREE_PUBLIC_KEY'],
  private_key: ENV['BRAINTREE_PRIVATE_KEY'],
  logger: Rails.logger
)

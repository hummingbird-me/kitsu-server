module Webhooks
  class StripeController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV.fetch('STRIPE_WEBHOOK_SECRET', nil)

    def notify
      payload = request.body.read
      signature = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(payload, signature, SECRET)

      StripeEventService.new(event).call

      head :no_content
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      render_jsonapi_error 400, 'Invalid payload'
    end
  end
end

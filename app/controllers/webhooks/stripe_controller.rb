module Webhooks
  class StripeController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV['STRIPE_WEBHOOK_SECRET']

    def notify
      payload = request.body.read
      signature = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(payload, signature, SECRET)

      StripeEventService.new(event).call

      head 204
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      render_jsonapi_error 400, 'Invalid payload'
    end
  end
end

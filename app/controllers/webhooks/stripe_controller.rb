module Webhooks
  class StripeController < ApplicationController
    include CustomControllerHelpers

    SECRET = ENV['STRIPE_WEBHOOK_SECRET']

    def notify
      payload = request.body.read
      signature = request.env['HTTP_STRIPE_SIGNATURE']
      event = Stripe::Webhook.construct_event(payload, signature, SECRET)

      StripeEventService.new(event).call

      render status: 200
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      render status: 400
    end
  end
end

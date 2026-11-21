# frozen_string_literal: true

class DeprecationSubscriber < ActiveSupport::Subscriber
  class DisallowedDeprecation < StandardError; end

  # Ruby's own deprecation warnings, reported like Rails' (ActiveSupport::Deprecation.warn is gone
  # since Rails 7.2)
  RUBY_DEPRECATOR = Rails.application.deprecators[:ruby] = ActiveSupport::Deprecation.new

  module RubyWarningSubscriber
    def warn(message, category: nil, **_kwargs)
      if category == :deprecated
        RUBY_DEPRECATOR.warn(message)
      else
        super
      end
    end
  end

  attach_to :rails
  def deprecation(event)
    exception = DisallowedDeprecation.new(event.payload[:message])
    exception.set_backtrace(event.payload[:callstack].map(&:to_s))
    Sentry.capture_exception(exception, level: :warning)
  end
end

Warning[:deprecated] = true
Warning.extend(DeprecationSubscriber::RubyWarningSubscriber)

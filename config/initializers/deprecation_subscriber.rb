# frozen_string_literal: true

class DeprecationSubscriber < ActiveSupport::Subscriber
  class DisallowedDeprecation < StandardError; end

  # Ruby's own deprecation warnings, reported like Rails' (ActiveSupport::Deprecation.warn is gone
  # since Rails 7.2)
  RUBY_DEPRECATOR = Rails.application.deprecators[:ruby] = ActiveSupport::Deprecation.new

  module RubyWarningSubscriber
    def warn(message, category: nil, **_kwargs)
      if category == :deprecated && gem_frozen_string_warning?(message)
        # Ruby 3.4 repeats this every time a gem mutates a string literal. faraday 0.17 (pinned by
        # stream-ruby) and elasticsearch-transport 5 (pinned by our ES 2 cluster) do so on every
        # request and can't be fixed from here, so only report the ones from our own code.
      elsif category == :deprecated
        RUBY_DEPRECATOR.warn(message)
      else
        super
      end
    end

    def gem_frozen_string_warning?(message)
      message.include?('will be frozen in the future') && message.start_with?(*Gem.path)
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

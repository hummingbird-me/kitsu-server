# frozen_string_literal: true

require 'typhoeus'

Ethon.logger = Logger.new(nil)

module Typhoeus
  class Request
    def finish(response, bypass_memoization = nil)
      crumb = Sentry::Breadcrumb.new(
        category: 'requests',
        type: 'http',
        data: {
          url:,
          method: options[:method],
          status_code: response.code,
          redirect_count: response.redirect_count,
          total_time: response.total_time
        },
        level: :debug
      )
      Sentry.add_breadcrumb(crumb)
    ensure
      super(response, bypass_memoization)
    end
  end
end

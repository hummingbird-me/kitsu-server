require 'typhoeus'

Ethon.logger = Logger.new(nil)

module Typhoeus
  class Request
    def finish(response, bypass_memoization = nil)
      Raven.breadcrumbs.record do |crumb|
        crumb.category = 'requests'
        crumb.type = 'http'
        crumb.data = {
          url: url,
          method: options[:method],
          status_code: response.code,
          redirect_count: response.redirect_count,
          total_time: response.total_time
        }
        crumb.level = :debug
      end
    ensure
      super(response, bypass_memoization)
    end
  end
end

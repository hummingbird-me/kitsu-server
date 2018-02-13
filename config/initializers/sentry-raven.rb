Raven.configure do |config|
  config.silence_ready = true
  config.excluded_exceptions += [
    'Rack::Utils::InvalidParameterError', # Rack was unable to decode a parameter
  ]
end

module RavenBreadcrumbs
  module NetHTTP
    def self.subscribe
      Net::HTTP.prepend(self)
    end

    def request(request, body = nil, &block)
      response = nil
      duration = Benchmark.realtime do
        response = super
      end
      raven_record_breadcrumb(request, response, duration)
      response
    end

    private

    def raven_record_breadcrumb(request, response, duration)
      Raven.breadcrumbs.record do |crumb|
        crumb.category = 'requests'
        crumb.type = 'http'
        crumb.data = {
          url: request.uri,
          method: request.method,
          status_code: response.code,
          total_time: duration
        }
        crumb.level = :debug
      end
    rescue e
      Raven.capture_exception(e)
    end
  end

  module ActiveRecord
    module_function

    def subscribe
      ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
        raven_record_breadcrumb(ActiveSupport::Notifications::Event.new(*args))
      end
    end

    def raven_record_breadcrumb(event)
      Raven.breadcrumbs.record do |crumb|
        crumb.category = 'db'
        crumb.type = 'sql'
        crumb.data = {
          name: event.payload[:name],
          sql: event.payload[:sql],
          total_time: (event.duration.to_f / 1000)
        }
        crumb.level = :debug
      end
    rescue e
      Raven.capture_exception(e)
    end
  end
end

RavenBreadcrumbs::NetHTTP.subscribe
RavenBreadcrumbs::ActiveRecord.subscribe

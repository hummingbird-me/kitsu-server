# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 6)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', 0)
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'development')
quiet

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch('WEB_CONCURRENCY', 2)

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
preload_app!

# Set up prometheus instrumentation and puma plugin.
before_worker_boot do
  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Process.start(type: 'web')
  PrometheusExporter::Instrumentation::ActiveRecord.start(
    custom_labels: { type: 'web' },
    config_labels: %i[database host]
  )
end

after_worker_boot do
  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Puma.start
end

# Set up puma worker killer to continuously refresh workers
before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.rolling_pre_term = ->(worker) {
      puts "Worker #{worker.inspect} being killed by rolling restart"
    }
  end
  PumaWorkerKiller.enable_rolling_restart(6.hours)
end

# Capture errors in Puma and send them to Sentry
lowlevel_error_handler do |ex, env|
  Sentry.capture_exception(
    ex,
    message: ex.message,
    extra: { puma: env, culprit: 'Puma' }
  )
  # note the below is just a Rack response
  [500, {}, [<<-MESSAGE.squish]]
    An unknown error has occurred. If you continue to have problems, contact help@kitsu.app\n
  MESSAGE
end

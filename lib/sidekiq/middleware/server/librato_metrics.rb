module Sidekiq
  module Middleware
    module Server
      class LibratoMetrics
        def call(_worker, job, queue)
          librato_opts = { tags: { queue: queue, worker: job['class'] }, inherit_tags: true }

          Librato.group 'sidekiq' do |g|
            g.timing 'queue.delay', (Time.now.to_f - job['enqueued_at']), librato_opts
            begin
              start_time = Time.now
              yield
              g.increment 'queue.processed.success', librato_opts
            rescue
              g.increment 'queue.processed.error', librato_opts
              raise
            ensure
              g.timing 'worker.time', ((Time.now - start_time) * 1000).to_i, librato_opts
            end
          end
        end
      end
    end
  end
end

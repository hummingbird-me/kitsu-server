module Sidekiq
  module Middleware
    module Server
      class Chewy
        def call(*, &block)
          ::Chewy.strategy(:atomic, &block)
        end
      end
    end
  end
end

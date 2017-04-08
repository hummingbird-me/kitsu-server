module Sidekiq
  module Middleware
    module Server
      class Chewy
        def call(*)
          ::Chewy.strategy(:atomic) do
            yield
          end
        end
      end
    end
  end
end

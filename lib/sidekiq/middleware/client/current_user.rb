module Sidekiq
  module Middleware
    module Client
      class CurrentUser
        def call(_, job, *)
          job['current_user'] = User.current&.id
          yield
        end
      end
    end
  end
end

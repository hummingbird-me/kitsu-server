module Sidekiq
  module Middleware
    module Server
      class CurrentUser
        def call(_, job, _)
          # Extract the User ID from job metadata
          user = User.find_by(id: job['current_user'])
          # Save it onto the thread
          Thread.current[:current_user] = user
          # Send it to Raven
          Raven.user_context(id: user.id, name: user.name) if user
          # Run Sidekiq job
          yield
        ensure
          Thread.current[:current_user] = nil
        end
      end
    end
  end
end

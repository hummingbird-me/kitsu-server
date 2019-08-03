module Accounts
  class SendConfirmationEmailWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'now'

    def perform(user_id)
      user = User.find(user_id)

      SendConfirmationEmail.call(user: user)
    end

    def self.perform_async(user)
      user = user.id if user.respond_to?(:id)
      super(user)
    end
  end
end

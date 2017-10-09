# RAILS-5: replace with config.action_mailer.deliver_later_queue_name
ActionMailer::DeliveryJob.class_eval do
  queue_as :soon
end

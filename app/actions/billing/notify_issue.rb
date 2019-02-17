module Billing
  class NotifyIssue < Action
    parameter :subscription, required: true

    def call
      ProMailer.billing_issue_email(subscription).deliver_later
    end
  end
end

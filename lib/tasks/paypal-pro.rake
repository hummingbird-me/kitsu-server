namespace :paypal_pro do
  desc 'Resave all paperclip attachments'
  task setup: :environment do
    [
      {
        name: 'PRO',
        cost: '19.00'
      },
      {
        name: 'PATRON',
        cost: '49.00'
      }
    ].each do |tier|
      PayPal::SDK.logger = Logger.new(nil)
      plan = PayPal::SDK::REST::Plan.new(
        name: "Kitsu #{tier[:name]}",
        description: "Yearly subscription to Kitsu #{tier[:name]}",
        type: 'INFINITE',
        payment_definitions: [{
          name: "Kitsu #{tier[:name]} Yearly",
          type: 'REGULAR',
          frequency_interval: '1',
          frequency: 'YEAR',
          amount: {
            currency: 'USD',
            value: tier[:cost]
          }
        }],
        merchant_preferences: {
          cancel_url: 'https://www.paypal.com/checkoutnow/error',
          return_url: 'https://www.paypal.com/checkoutnow/error',
          max_fail_attempts: '0',
          auto_bill_amount: 'YES',
          initial_fail_amount_action: 'CANCEL'
        }
      )
      plan.create!
      puts "PAYPAL_#{tier[:name]}_PLAN=#{plan.id}"
    end
  end
end

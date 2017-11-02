require 'update_in_batches'

class FillOnboardingStatusOnUsers < ActiveRecord::Migration
  using UpdateInBatches
  disable_ddl_transaction!

  def change
    say_with_time 'Filling onboarding_status' do
      User.all.update_in_batches(onboarding_status: 100)
    end
  end
end

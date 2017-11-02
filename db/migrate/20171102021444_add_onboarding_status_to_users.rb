class AddOnboardingStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :onboarding_status, :integer
  end
end

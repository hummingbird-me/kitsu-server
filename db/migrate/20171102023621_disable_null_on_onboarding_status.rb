class DisableNullOnOnboardingStatus < ActiveRecord::Migration
  def change
    change_column_default :users, :onboarding_status, 0
    change_column_null :users, :onboarding_status, false, 100
  end
end

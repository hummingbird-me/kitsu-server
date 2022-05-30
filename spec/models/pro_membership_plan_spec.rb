require 'rails_helper'

RSpec.describe ProMembershipPlan, type: :model do
  before do
    create_list(:nonrecurring_pro_membership_plan, 10)
    create_list(:recurring_pro_membership_plan, 5)
  end

  describe 'recurring scope' do
    it 'does not include any nonrecurring plans' do
      scoped = ProMembershipPlan.recurring
      nonrecurring_plans = scoped.where(recurring: false).pluck(:recurring)
      expect(nonrecurring_plans).to be_empty
    end
  end

  describe 'nonrecurring scope' do
    it 'does not include any recurring plans' do
      scoped = ProMembershipPlan.nonrecurring
      recurring_plans = scoped.where(recurring: true).pluck(:recurring)
      expect(recurring_plans).to be_empty
    end
  end
end

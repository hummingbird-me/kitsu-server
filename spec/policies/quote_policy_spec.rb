require 'rails_helper'

RSpec.describe QuotePolicy do
  let(:other) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:quote) { build(:quote, user: admin.resource_owner) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should not allow anons') { should_not permit(nil, quote) }
    it('should not allow users') { should_not permit(other, quote) }
    it('should allow admins') { should permit(admin, quote) }
  end
end

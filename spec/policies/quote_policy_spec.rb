require 'rails_helper'

RSpec.describe QuotePolicy do
  let(:owner) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:quote) { build(:quote, user: owner.resource_owner) }
  subject { described_class }

  permissions :create? do
    it('should not allow anons') { should_not permit(nil, quote) }
    it('should allow users') { should permit(owner, quote) }
  end

  permissions :update?, :destroy? do
    it('should not allow anons') { should_not permit(nil, quote) }
    it('should allow users') { should permit(owner, quote) }
    it('should allow admins') { should permit(admin, quote) }
  end
end

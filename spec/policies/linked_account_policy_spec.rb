require 'rails_helper'

RSpec.describe LinkedAccountPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:user) { token_for build(:user, id: 2) }
  let(:linked_account) do
    build(:linked_account, user: owner.resource_owner)
  end
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow owner') { should permit(owner, linked_account) }
    it('should not allow random user') { should_not permit(user, linked_account) }
    it('should not allow anon') { should_not permit(nil, linked_account) }
  end
end

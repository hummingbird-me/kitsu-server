require 'rails_helper'

RSpec.describe LinkedAccountPolicy do
  subject { described_class }

  let(:owner) { token_for create(:user, id: 1) }
  let(:user) { token_for create(:user, id: 2) }
  let(:linked_account) do
    build(:linked_account, user: owner.resource_owner)
  end

  permissions :create?, :update?, :destroy? do
    it('allows owner') { is_expected.to permit(owner, linked_account) }
    it('does not allow random user') { is_expected.not_to permit(user, linked_account) }
    it('does not allow anon') { is_expected.not_to permit(nil, linked_account) }
  end
end

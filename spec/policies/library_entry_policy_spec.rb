require 'rails_helper'

RSpec.describe LibraryEntryPolicy do
  subject { described_class }

  let(:owner) { token_for create(:user, id: 1) }
  let(:user) { token_for create(:user, id: 2) }
  let(:entry) { build(:library_entry, user: owner.resource_owner) }

  permissions :create?, :update?, :destroy? do
    it('allows owner') { is_expected.to permit(owner, entry) }
    it('does not allow random dude') { is_expected.not_to permit(user, entry) }
    it('does not allow anon') { is_expected.not_to permit(nil, entry) }
  end
end

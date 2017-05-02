require 'rails_helper'

RSpec.describe LibraryEntryPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:user) { token_for build(:user, id: 2) }
  let(:admin) { token_for create(:user, :admin) }
  let(:entry) { build(:library_entry, user: owner.resource_owner) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow owner') { should permit(owner, entry) }
    it('should not allow admin') { should_not permit(admin, entry) }
    it('should not allow random dude') { should_not permit(user, entry) }
    it('should not allow anon') { should_not permit(nil, entry) }
  end
end

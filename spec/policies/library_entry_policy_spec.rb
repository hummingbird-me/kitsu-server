require 'rails_helper'

RSpec.describe LibraryEntryPolicy do
  let(:owner) { build(:user) }
  let(:user) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:entry) { build(:library_entry, user: owner) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow owner') { should permit(owner, entry) }
    it('should allow admin') { should permit(admin, entry) }
    it('should not allow random dude') { should_not permit(user, entry) }
    it('should not allow anon') { should_not permit(nil, entry) }
  end
end

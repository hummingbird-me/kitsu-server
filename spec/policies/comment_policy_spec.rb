require 'rails_helper'

RSpec.describe CommentPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:admin) { token_for create(:user, :admin) }
  let(:comment) { build(:comment, user: owner.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should allow owner') { should permit(owner, comment) }
    it('should allow admin') { should permit(admin, comment) }
    it('should not allow other users') { should_not permit(other, comment) }
    it('should not allow anons') { should_not permit(nil, comment) }
  end

  permissions :create? do
    it('should allow owner') { should permit(owner, comment) }
    it('should not allow admin') { should_not permit(admin, comment) }
    it('should not allow random dude') { should_not permit(other, comment) }
    it('should not allow anon') { should_not permit(nil, comment) }
  end

  permissions :destroy? do
    it('should allow owner') { should permit(owner, comment) }
    it('should allow admin') { should permit(admin, comment) }
    it('should now allow random dude') { should_not permit(other, comment) }
    it('should not allow anon') { should_not permit(nil, comment) }
  end
end

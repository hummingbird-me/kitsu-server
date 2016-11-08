require 'rails_helper'

RSpec.describe CommentPolicy do
  let(:owner) { build(:user) }
  let(:other) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:comment) { build(:comment, user: owner) }
  subject { described_class }

  permissions :update? do
    context 'with old comment' do
      let(:comment) { build(:comment, user: owner, created_at: 1.hour.ago) }
      it('should not allow owner') { should_not permit(owner, comment) }
      it('should allow admin') { should permit(admin, comment) }
      it('should not allow others') { should_not permit(other, comment) }
      it('should not allow anons') { should_not permit(nil, comment) }
    end
    context 'with recent comment' do
      it('should allow owner') { should permit(owner, comment) }
      it('should allow admin') { should permit(admin, comment) }
      it('should not allow other users') { should_not permit(other, comment) }
      it('should not allow anons') { should_not permit(nil, comment) }
    end
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

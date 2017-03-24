require 'rails_helper'

RSpec.describe PostPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:admin) { token_for create(:user, :admin) }
  let(:post) { build(:post, user: owner.resource_owner) }
  subject { described_class }

  permissions :update? do
    context 'old post' do
      let(:post) do
        build(:post, user: owner.resource_owner, created_at: 1.hour.ago)
      end
      it('should not allow owner') { should_not permit(owner, post) }
      it('should allow admin') { should permit(admin, post) }
      it('should not allow others') { should_not permit(other, post) }
      it('should not allow anons') { should_not permit(nil, post) }
    end
    context 'recent post' do
      it('should allow owner') { should permit(owner, post) }
      it('should allow admin') { should permit(admin, post) }
      it('should not allow other users') { should_not permit(other, post) }
      it('should not allow anons') { should_not permit(nil, post) }
    end
  end

  permissions :create? do
    it('should allow owner') { should permit(owner, post) }
    it('should not allow admin') { should_not permit(admin, post) }
    it('should not allow random dude') { should_not permit(other, post) }
    it('should not allow anon') { should_not permit(nil, post) }
  end

  permissions :destroy? do
    it('should allow owner') { should permit(owner, post) }
    it('should allow admin') { should permit(admin, post) }
    it('should now allow random dude') { should_not permit(other, post) }
    it('should not allow anon') { should_not permit(nil, post) }
  end
end

require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { build(:user) }
  let(:user_token) { token_for(user) }
  let(:admin) { create(:user, :admin) }
  let(:admin_token) { token_for(admin) }
  let(:other) { build(:user) }
  let(:other_token) { token_for(other) }
  subject { described_class }

  permissions :create? do
    it('should allow admins') { should permit(admin_token, other) }
    it('should allow normal users') { should permit(user_token, other) }
    it('should allow anon') { should permit(nil, other) }
  end

  permissions :update? do
    context 'for self' do
      it('should allow normal users') { should permit(user_token, user) }
      it('should allow admins') { should permit(admin_token, admin) }
    end
    context 'for other' do
      it('should not allow normal users') { should_not permit(user_token, other) }
      it('should not allow anons') { should_not permit(nil, other) }
      it('should allow admins') { should permit(admin_token, other) }
    end
  end

  permissions :destroy? do
    it('should allow admins') { should permit(admin_token, other) }
    it('should not allow normal users') { should_not permit(user_token, other) }
    it('should not allow anon') { should_not permit(nil, other) }
  end
end

require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { build(:user) }
  let(:user_token) { token_for(user) }
  let(:community_mod) { create(:user, permissions: %i[community_mod]) }
  let(:community_mod_token) { token_for(community_mod) }
  let(:other) { build(:user) }
  let(:other_token) { token_for(other) }
  subject { described_class }

  permissions :create? do
    it('should allow community mods') { should permit(community_mod_token, other) }
    it('should allow normal users') { should permit(user_token, other) }
    it('should allow anon') { should permit(nil, other) }
  end

  permissions :update? do
    context 'for self' do
      it('should allow normal users') { should permit(user_token, user) }
      it('should allow community mods') { should permit(community_mod_token, community_mod) }
    end
    context 'for other' do
      it('should not allow normal users') { should_not permit(user_token, other) }
      it('should not allow anons') { should_not permit(nil, other) }
      it('should allow community mods') { should permit(community_mod_token, other) }
    end
  end

  permissions :destroy? do
    it('should allow community mods') { should permit(community_mod_token, other) }
    it('should not allow normal users') { should_not permit(user_token, other) }
    it('should not allow anon') { should_not permit(nil, other) }
  end
end

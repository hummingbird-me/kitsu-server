require 'rails_helper'

RSpec.describe MediaReactionPolicy do
  let(:user) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:anime) { build(:anime) }
  let(:media_reaction) do
    build(:media_reaction, user: user.resource_owner, anime: anime)
  end
  let(:other) { build(:media_reaction) }
  subject { described_class }

  permissions :update? do
    it('should not allow anons') {
      should_not permit(nil, media_reaction)
    }
  end

  permissions :create? do
    it('should not allow anons') {
      should_not permit(nil, media_reaction)
    }
    it('should not allow for others') { should_not permit(user, other) }
    it('should allow for yourself') {
      should permit(user, media_reaction)
    }
  end

  permissions :destroy? do
    it('should allow admin') { should permit(admin, media_reaction) }
    it('should allow for yourself') {
      should permit(user, media_reaction)
    }
  end
end

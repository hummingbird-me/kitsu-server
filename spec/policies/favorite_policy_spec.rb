require 'rails_helper'

RSpec.describe FavoritePolicy do
  let(:owner) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:favorite) { build(:favorite, user: owner.resource_owner) }
  subject { described_class }

  permissions :update?, :create?, :destroy? do
    it('should allow owner') { should permit(owner, favorite) }
    it('should not allow other') { should_not permit(other, favorite) }
  end
end

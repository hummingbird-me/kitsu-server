require 'rails_helper'

RSpec.describe FavoritePolicy do
  let(:owner) { build(:user) }
  let(:other) { build(:user) }
  let(:favorite) { build(:favorite, user: owner) }
  subject { described_class }

  permissions :show? do
    it('should allow owner') { should permit(owner, favorite) }
    it('should allow other') { should permit(other, favorite) }
  end

  permissions :update?, :create?, :destroy? do
    it('should allow owner') { should permit(owner, favorite) }
    it('should not allow other') { should_not permit(other, favorite) }
  end
end

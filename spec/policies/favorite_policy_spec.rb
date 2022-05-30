require 'rails_helper'

RSpec.describe FavoritePolicy do
  subject { described_class }

  let(:owner) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:favorite) { build(:favorite, user: owner.resource_owner) }

  permissions :update?, :create?, :destroy? do
    it('allows owner') { is_expected.to permit(owner, favorite) }
    it('does not allow other') { is_expected.not_to permit(other, favorite) }
  end
end

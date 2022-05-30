require 'rails_helper'

RSpec.describe CategoryFavoritePolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:favorite) { build(:category_favorite, user: user.resource_owner) }

  permissions :update?, :create?, :destroy? do
    it('allows user') { is_expected.to permit(user, favorite) }
    it('does not allow other') { is_expected.not_to permit(other, favorite) }
  end
end

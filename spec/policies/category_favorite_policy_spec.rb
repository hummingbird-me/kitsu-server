require 'rails_helper'

RSpec.describe CategoryFavoritePolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:favorite) { build(:category_favorite, user: user.resource_owner) }
  subject { described_class }

  permissions :update?, :create?, :destroy? do
    it('should allow user') { should permit(user, favorite) }
    it('should not allow other') { should_not permit(other, favorite) }
  end
end

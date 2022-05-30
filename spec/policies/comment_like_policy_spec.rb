require 'rails_helper'

RSpec.describe CommentLikePolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:like) { build(:comment_like, user: user.resource_owner) }
  let(:other) { build(:comment_like) }

  permissions :update? do
    it('does not allow users') { is_expected.not_to permit(user, like) }
    it('does not allow anons') { is_expected.not_to permit(nil, like) }
  end

  permissions :create?, :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, like) }
    it('allows for yourself') { is_expected.to permit(user, like) }
    it('does not allow for others') { is_expected.not_to permit(user, other) }
  end
end

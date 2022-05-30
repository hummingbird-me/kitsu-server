require 'rails_helper'

RSpec.describe MediaIgnorePolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:media) { build(:anime) }
  let(:other) { token_for create(:user, id: 2) }
  let(:media_ignore) do
    build(:media_ignore, user: user.resource_owner, media: media)
  end

  permissions :update? do
    it('does not allow users') { is_expected.not_to permit(user, media_ignore) }
    it('does not allow anons') { is_expected.not_to permit(nil, media_ignore) }
  end

  permissions :create?, :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, media_ignore) }

    context 'when you are the user' do
      it('allows') { is_expected.to permit(user, media_ignore) }
    end

    context 'when you are not the user' do
      it('does not allow') { is_expected.not_to permit(other, media_ignore) }
    end
  end
end

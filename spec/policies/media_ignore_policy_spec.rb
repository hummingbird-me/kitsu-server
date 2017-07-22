require 'rails_helper'

RSpec.describe MediaIgnorePolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:media) { build(:anime) }
  let(:other) { token_for build(:user, id: 2) }
  let(:media_ignore) do
    build(:media_ignore, user: user.resource_owner, media: media)
  end
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, media_ignore) }
    it('should not allow anons') { should_not permit(nil, media_ignore) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, media_ignore) }

    context 'when you are the user' do
      it('should allow') { should permit(user, media_ignore) }
    end

    context 'when you are not the user' do
      it('should not allow') { should_not permit(other, media_ignore) }
    end
  end
end

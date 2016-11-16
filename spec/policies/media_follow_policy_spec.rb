require 'rails_helper'

RSpec.describe MediaFollowPolicy do
  let(:user) { build(:user) }
  let(:media) { build(:anime) }
  let(:other) { build(:user) }
  let(:follow) { build(:media_follow, user: user, media: media) }
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, follow) }
    it('should not allow anons') { should_not permit(nil, follow) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, follow) }

    context 'when you are the follower' do
      it('should allow') { should permit(user, follow) }
    end

    context 'when you are not the follower' do
      it('should not allow') { should_not permit(other, follow) }
    end
  end
end

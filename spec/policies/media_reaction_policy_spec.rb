require 'rails_helper'

RSpec.describe MediaReactionPolicy do
  let(:user) { token_for build(:user) }
  let(:media_reaction) { build(:media_reaction, user: user.resource_owner) }
  let(:other) { build(:media_reaction) }
  subject { described_class }

  permissions :update? do
    it('should not allow users') { should_not permit(user, media_reaction) }
    it('should not allow anons') { should_not permit(nil, media_reaction) }
  end

  permissions :create?, :destroy? do
    it('should not allow anons') { should_not permit(nil, media_reaction) }
    it('should allow for yourself') { should permit(user, media_reaction) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end

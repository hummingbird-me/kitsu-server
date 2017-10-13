require 'rails_helper'

RSpec.describe VolumePolicy do
  let(:user) { token_for build(:user) }
  let(:admin) { token_for create(:user, :admin) }
  let(:volume) { build(:volume) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow admin') { should permit(admin, volume) }
    it('should not allow for user') {
      should_not permit(user, volume)
    }
  end
end

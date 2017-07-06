require 'rails_helper'

RSpec.describe AmaPolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:ama) { build(:ama, author: user.resource_owner) }
  subject { described_class }

  permissions :update?, :create?, :destroy? do
    it('should allow user') { should permit(user, ama) }
    it('should not allow other') { should_not permit(other, ama) }
  end
end

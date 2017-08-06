require 'rails_helper'

RSpec.describe AMASubscriberPolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:ama_subscriber) { build(:ama_subscriber, user: user.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should not allow user') { should_not permit(user, ama_subscriber) }
    it('should not allow other') { should_not permit(other, ama_subscriber) }
  end

  permissions :create?, :destroy? do
    it('should allow user') { should permit(user, ama_subscriber) }
    it('should not allow other') { should_not permit(other, ama_subscriber) }
  end
end

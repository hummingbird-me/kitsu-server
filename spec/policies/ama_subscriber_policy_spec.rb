require 'rails_helper'

RSpec.describe AMASubscriberPolicy do
  subject { described_class }

  let(:user) { token_for create(:user, id: 1) }
  let(:other) { token_for create(:user, id: 2) }
  let(:ama_subscriber) { build(:ama_subscriber, user: user.resource_owner) }

  permissions :update? do
    it('does not allow user') { is_expected.not_to permit(user, ama_subscriber) }
    it('does not allow other') { is_expected.not_to permit(other, ama_subscriber) }
  end

  permissions :create?, :destroy? do
    it('allows user') { is_expected.to permit(user, ama_subscriber) }
    it('does not allow other') { is_expected.not_to permit(other, ama_subscriber) }
  end
end

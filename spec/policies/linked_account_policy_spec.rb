require 'rails_helper'

RSpec.describe LinkedAccountPolicy do
  let(:owner) { token_for build(:user, id: 1) }
  let(:user) { token_for build(:user, id: 2) }
  let(:admin) { token_for create(:user, :admin) }
  let(:linked_account) do
    build(:linked_account, user: owner.resource_owner)
  end
  subject { described_class }

  # (it's much cleaner on one line)
  # rubocop:disable Metrics/LineLength
  permissions :create?, :update?, :destroy? do
    it('should allow owner') { should permit(owner, linked_account) }
    it('should not allow admin') { should_not permit(admin, linked_account) }
    it('should not allow random user') { should_not permit(user, linked_account) }
    it('should not allow anon') { should_not permit(nil, linked_account) }
  end
  # rubocop:enable Metrics/LineLength
end

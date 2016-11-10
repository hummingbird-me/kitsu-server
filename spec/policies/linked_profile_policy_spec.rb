require 'rails_helper'

RSpec.describe LinkedProfilePolicy do
  let(:owner) { build(:user) }
  let(:user) { build(:user) }
  let(:admin) { create(:user, :admin) }
  let(:linked_site) { build(:linked_site) }
  let(:linked_profile) do
    build(:linked_profile, user: owner, linked_site: linked_site)
  end
  subject { described_class }

  # (it's much cleaner on one line)
  # rubocop:disable Metrics/LineLength
  permissions :create?, :update?, :destroy? do
    it('should allow owner') { should permit(owner, linked_profile) }
    it('should allow admin') { should permit(admin, linked_profile) }
    it('should not allow random user') { should_not permit(user, linked_profile) }
    it('should not allow anon') { should_not permit(nil, linked_profile) }
  end
  # rubocop:enable Metrics/LineLength
end

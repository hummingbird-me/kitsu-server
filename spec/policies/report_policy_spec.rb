require 'rails_helper'

RSpec.describe ReportPolicy do
  let(:user) { token_for build(:user, id: 1) }
  let(:other) { token_for build(:user, id: 2) }
  let(:admin) { token_for create(:user, :admin) }
  let(:report) { build(:report, user: user.resource_owner) }
  subject { described_class }

  permissions :update? do
    it('should not allow anon') { should_not permit(nil, report) }
    it('should not allow random users') { should_not permit(other, report) }
    it('should allow the author') { should permit(user, report) }
    it('should allow admins') { should permit(admin, report) }
  end

  permissions :create? do
    it('should not allow anon') { should_not permit(nil, report) }
    it('should allow users') { permit(user, report) }
  end

  permissions :destroy? do
    it('should not allow admin') { should_not permit(admin, report) }
    it('should not allow reporter') { should_not permit(user, report) }
  end
end

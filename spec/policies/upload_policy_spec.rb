require 'rails_helper'
RSpec.describe UploadPolicy do
  let(:user) { token_for build(:user) }
  let(:upload) { build(:upload, user: user.resource_owner) }
  let(:other) { build(:upload) }
  subject { described_class }

  permissions :create? do
    it('should allow users') { should permit(user, upload) }
    it('should not allow anons') { should_not permit(nil, upload) }
  end

  permissions :show? do
    it('should allow users') { should permit(user, upload) }
    it('should allow anons') { should permit(nil, upload) }
  end

  permissions :update?, :destroy? do
    it('should not allow anons') { should_not permit(nil, upload) }
    it('should allow for yourself') { should permit(user, upload) }
    it('should not allow for others') { should_not permit(user, other) }
  end
end

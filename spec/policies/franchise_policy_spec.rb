require 'rails_helper'

RSpec.describe FranchisePolicy do
  let(:user) { build(:user) }
  let(:franchise) { build(:franchise) }
  subject { described_class }

  permissions :show? do
    it('should allow anons') { should permit(nil, franchise) }
    it('should allow users') { should permit(user, franchise) }
    end
  end
end

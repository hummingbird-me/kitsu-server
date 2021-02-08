require 'rails_helper'

RSpec.describe QuotePolicy do
  let(:other) { token_for create(:user) }
  let(:database_mod) { token_for create(:user, permissions: %i[database_mod]) }
  let(:quote) { build(:quote, user: database_mod.resource_owner) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should not allow anons') { should_not permit(nil, quote) }
    it('should not allow users') { should_not permit(other, quote) }
    it('should allow database mods') { should permit(database_mod, quote) }
  end
end

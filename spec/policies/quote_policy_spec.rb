require 'rails_helper'

RSpec.describe QuotePolicy do
  subject { described_class }

  let(:other) { token_for create(:user) }
  let(:database_mod) { token_for create(:user, permissions: %i[database_mod]) }
  let(:quote) { build(:quote, user: database_mod.resource_owner) }

  permissions :create?, :update?, :destroy? do
    it('does not allow anons') { is_expected.not_to permit(nil, quote) }
    it('does not allow users') { is_expected.not_to permit(other, quote) }
    it('allows database mods') { is_expected.to permit(database_mod, quote) }
  end
end

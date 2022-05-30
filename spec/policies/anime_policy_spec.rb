require 'rails_helper'

RSpec.describe AnimePolicy do
  subject { described_class }

  let(:user) { token_for create(:user) }
  let(:pervert) { token_for create(:user, sfw_filter: false) }
  let(:database_mod) { token_for create(:user, permissions: %i[database_mod]) }
  let(:anime) { build(:anime) }
  let(:hentai) { build(:anime, :nsfw) }

  permissions :create?, :update?, :destroy? do
    it('allows database mods') { is_expected.to permit(database_mod, anime) }
    it('does not allow normal users') { is_expected.not_to permit(user, anime) }
    it('does not allow anon') { is_expected.not_to permit(nil, anime) }
  end
end

require 'rails_helper'

RSpec.describe AnimePolicy do
  let(:user) { token_for create(:user) }
  let(:pervert) { token_for create(:user, sfw_filter: false) }
  let(:database_mod) { token_for create(:user, permissions: %i[database_mod]) }
  let(:anime) { build(:anime) }
  let(:hentai) { build(:anime, :nsfw) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow database mods') { should permit(database_mod, anime) }
    it('should not allow normal users') { should_not permit(user, anime) }
    it('should not allow anon') { should_not permit(nil, anime) }
  end
end

require 'rails_helper'

RSpec.describe AnimePolicy do
  let(:user) { token_for build(:user) }
  let(:pervert) { token_for build(:user, sfw_filter: false) }
  let(:admin) { token_for create(:user, :admin) }
  let(:mod) { token_for create(:user, :anime_admin) }
  let(:anime) { build(:anime) }
  let(:hentai) { build(:anime, :nsfw) }
  subject { described_class }

  permissions :create?, :update?, :destroy? do
    it('should allow admins') { should permit(admin, anime) }
    it('should not allow normal users') { should_not permit(user, anime) }
    it('should not allow anon') { should_not permit(nil, anime) }
  end
end

require 'rails_helper'

RSpec.describe BokuNoPicoBadge do
  let!(:user) { create(:user) }
  let!(:anime) { create(:anime, titles: { en_jp: 'Bocu No Pico'}) }
  let!(:library) { create(:library_entry, media: anime) }

  describe 'title' do

    it 'has title' do
      badge = BokuNoPicoBadge.new(user)
      expect(badge.title).to 'foo'
    end
  end
end

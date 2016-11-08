require 'rails_helper'

RSpec.describe TheAdventureBeginBadge do
  let!(:user) { create(:user, bio: '') }

  describe 'bestowment creation' do
    context 'without user bio param' do
      it 'dont create bestowment' do
        expect(Bestowment.all.count).to eq(0)
      end
    end

    context 'with full user bio param' do
      before do
        user.bio = 'Human'
        user.save
      end

      it 'create bestowment' do
        expect(Bestowment.all.count).to eq(1)
      end
    end
  end
end

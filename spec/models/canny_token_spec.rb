require 'rails_helper'

RSpec.describe CannyToken do
  describe '#user_data' do
    subject { CannyToken.new(user) }

    let(:user) { build(:user, :with_avatar) }

    it 'contains name' do
      expect(subject.user_data).to include(:name)
      expect(subject.user_data[:name]).to eq(user.name)
    end

    it 'contains id' do
      user.save! # So that we have an ID
      expect(subject.user_data).to include(:id)
      expect(subject.user_data[:id]).to eq(user.id)
    end

    it 'contains email' do
      expect(subject.user_data).to include(:email)
      expect(subject.user_data[:email]).to eq(user.email)
    end

    context 'for a user with an avatar' do
      let(:user) { create(:user, :with_avatar) }

      it 'contains an avatarURL key' do
        user.avatar_derivatives!
        expect(subject.user_data).to include(:avatarURL)
      end
    end
  end
end

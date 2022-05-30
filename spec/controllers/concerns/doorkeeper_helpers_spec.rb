require 'rails_helper'

RSpec.describe DoorkeeperHelpers do
  let(:controller) do
    Class.new do
      def doorkeeper_token; end

      include DoorkeeperHelpers

      def render(*); end
    end
  end
  let(:instance) { controller.new }

  describe '#current_user' do
    it 'returns the token when there is a user logged in' do
      user = build(:user)
      token = token_for(user)
      allow(instance).to receive(:doorkeeper_token) { token }
      expect(instance.current_user).to eq(token)
    end

    it 'returns nil when there is nobody logged in' do
      allow(instance).to receive(:doorkeeper_token).and_return(nil)
      expect(instance.current_user).to be_nil
    end
  end

  describe '#signed_in?' do
    it 'returns true if logged in' do
      user = build(:user)
      allow(instance).to receive(:current_user) { token_for(user) }
      expect(instance.signed_in?).to be true
    end

    it 'returns false if not logged in' do
      allow(instance).to receive(:current_user).and_return(nil)
      expect(instance.signed_in?).to be false
    end
  end
end

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

  context '#current_user' do
    it 'should return the token when there is a user logged in' do
      user = build(:user)
      token = token_for(user)
      allow(instance).to receive(:doorkeeper_token) { token }
      expect(instance.current_user).to eq(token)
    end
    it 'should return nil when there is nobody logged in' do
      allow(instance).to receive(:doorkeeper_token) { nil }
      expect(instance.current_user).to be_nil
    end
  end

  context '#signed_in?' do
    it 'should return true if logged in' do
      allow(instance).to receive(:current_user) { build(:user) }
      expect(instance.signed_in?).to be true
    end
    it 'should return false if not logged in' do
      allow(instance).to receive(:current_user) { nil }
      expect(instance.signed_in?).to be false
    end
  end
end

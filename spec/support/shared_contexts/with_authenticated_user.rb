# frozen_string_literal: true

RSpec.shared_context 'with authenticated user' do
  let(:user) { create(:user) }
  let(:token) { token_for(user) }
  let(:context) { { token: token, user: user } }
end

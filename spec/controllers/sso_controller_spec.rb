require 'rails_helper'

RSpec.describe SSOController, type: :controller do
  let(:user) { create(:user) }

  describe '#canny' do
    context 'when logged in' do
      it 'responds with a token' do
        sign_in user
        get :canny
        expect(response).to have_http_status(:ok)
        expect(response.body).to match_json_expression(token: String)
      end
    end

    describe 'when logged out' do
      it 'responds with an error' do
        get :canny
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to match_json_expression(
          errors: [{ status: 403, detail: String }]
        )
      end
    end
  end
end

require 'rails_helper'

RSpec.describe SSOController, type: :controller do
  let(:user) { create(:user) }

  describe '#canny' do
    context 'when logged in' do
      it 'should respond with a token' do
        sign_in user
        get :canny
        expect(response).to have_http_status(:ok)
        expect(response.body).to match_json_expression(token: String)
      end
    end

    describe 'when logged out' do
      it 'should respond with an error' do
        get :canny
        expect(response).to have_http_status(403)
        expect(response.body).to match_json_expression(
          errors: [{ status: 403, detail: String }]
        )
      end
    end
  end
end

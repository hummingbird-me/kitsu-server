require 'rails_helper'
require 'google/apis/androidpublisher_v3'

RSpec.describe ProSubscriptionController, type: :controller do
  let(:user) { create(:user) }

  describe '#ios' do
    include_context 'Stubbed Apple Receipt Verification'

    context 'with a valid receipt' do
      it 'creates an AppleSubscription object for me' do
        sign_in user
        stub_receipt_verification(
          latest_receipt_info: {
            purchase_date: '2012-04-30T15:05:55.000+00:00',
            expires_date: '2012-04-30T15:05:55.000+00:00',
            original_transaction_id: '_TEST_'
          }
        )
        expect {
          post :ios, params: { receipt: 'TEST_RECEIPT', tier: 'pro' }
        }.to(change { user.pro_subscription })
      end
    end

    context 'with a malformed receipt' do
      it 'gives an error message' do
        sign_in user
        stub_receipt_verification(status: 21002) # rubocop:disable Style/NumericLiterals
        post :ios, params: { receipt: 'TEST_RECEIPT', tier: 'pro' }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to have_jsonapi_error(status: 400, detail: /malformed/i)
      end
    end

    context 'with an internal error from Apple' do
      it 'gives a bad gateway error' do
        sign_in user
        stub_receipt_verification(status: 21150) # rubocop:disable Style/NumericLiterals
        post :ios, params: { receipt: 'TEST_RECEIPT', tier: 'pro' }
        expect(response).to have_http_status(:bad_gateway)
        expect(response.body).to have_jsonapi_error(status: 502, detail: /Failed to connect/i)
      end
    end
  end

  describe '#google_play' do
    include_context 'Stubbed Android Publisher Service'

    context 'with a valid token' do
      it 'creates a GooglePlaySubscription object for me' do
        expect(api).to receive(:get_purchase_subscription)
        sign_in user
        expect {
          post :google_play, params: { token: 'TEST', tier: 'pro' }
        }.to(change { user.pro_subscription })
      end

      it 'returns the subscription in JSON' do
        expect(api).to receive(:get_purchase_subscription)
        sign_in user
        post :google_play, params: { token: 'TEST', tier: 'pro' }
        expect(Oj.load(response.body)).to match_json_expression(
          user: user.id,
          service: 'google_play',
          tier: 'pro'
        )
      end
    end

    context 'with a server error' do
      it 'returns a bad gateway error' do
        expect(api).to receive(:get_purchase_subscription).and_raise(Google::Apis::ServerError, '')
        sign_in user
        post :google_play, params: { token: 'TEST', tier: 'pro' }
        expect(response).to have_http_status(:bad_gateway)
        expect(response.body).to have_jsonapi_error(status: 502, detail: /went wrong.*Google Play/i)
      end
    end

    context 'with a client error' do
      it 'returns a 400 error' do
        expect(api).to receive(:get_purchase_subscription).and_raise(Google::Apis::ClientError, '')
        sign_in user
        post :google_play, params: { token: 'TEST', tier: 'pro' }
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to have_jsonapi_error(status: 400, detail: /client error/i)
      end
    end
  end

  describe '#destroy' do
    context 'with an Apple subscription' do
      it 'returns a 400 error' do
        ProSubscription::AppleSubscription.create!(billing_id: 'TEST', user: user, tier: :pro)
        sign_in user
        delete :destroy
        expect(response).to have_http_status(:bad_request)
        expect(response.body).to have_jsonapi_error(status: 400, detail: /Cannot cancel/i)
      end
    end

    context 'with a Stripe subscription' do
      let(:stripe_mock) { StripeMock.create_test_helper }

      before do
        stripe_mock.create_plan(id: 'pro-yearly')
        user.stripe_customer.source = stripe_mock.generate_card_token
        user.stripe_customer.save
        ProSubscription::StripeSubscription.create!(user: user, tier: :pro)
        sign_in user
      end

      it 'returns an empty JSON object' do
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{}')
      end

      it 'removes my subscription' do
        expect {
          delete :destroy
        }.to(change { user.reload.pro_subscription })
        expect(user.reload.pro_subscription).to be_nil
      end
    end

    context 'with a Google Play subscription' do
      include_context 'Stubbed Android Publisher Service'

      before do
        ProSubscription::GooglePlaySubscription.create!(
          user: user,
          billing_id: 'TEST',
          tier: :pro
        )
        sign_in user
      end

      it 'returns an empty JSON object' do
        expect(api).to receive(:cancel_purchase_subscription)
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{}')
      end

      it 'removes my subscription' do
        expect(api).to receive(:cancel_purchase_subscription)
        expect {
          delete :destroy
        }.to(change { user.reload.pro_subscription })
        expect(user.reload.pro_subscription).to be_nil
      end
    end
  end

  describe '#show' do
    context 'with a subscription' do
      it 'serializes the subscription into JSON' do
        ProSubscription::AppleSubscription.create!(user: user, billing_id: 'TEST', tier: :pro)
        sign_in user
        get :show
        expect(Oj.load(response.body)).to match_json_expression(
          user: user.id,
          service: String,
          tier: 'pro'
        )
      end
    end

    context 'with no current subscription' do
      it 'returns a 404' do
        sign_in user
        get :show
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

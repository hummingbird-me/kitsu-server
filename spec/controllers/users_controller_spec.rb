require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  USER ||= { name: String, pastNames: Array }.freeze
  CURRENT_USER ||= { email: String }.merge(USER).freeze
  let(:user) { create(:user) }

  describe '#index' do
    describe 'with filter[self]' do
      it 'should respond with a user when authenticated' do
        sign_in user
        get :index, params: { filter: { self: 'yes' } }
        expect(response.body).to have_resources(CURRENT_USER.dup, 'users')
        expect(response).to have_http_status(:ok)
      end
      it 'should respond with an empty list when unauthenticated' do
        get :index, params: { filter: { self: 'yes' } }
        expect(response.body).to have_empty_resource
      end
    end
    describe 'with filter[name]' do
      it 'should find by username' do
        get :index, params: { filter: { name: user.name } }
        user_json = USER.merge(name: user.name)
        expect(response.body).to have_resources(user_json, 'users')
      end
    end
  end

  describe '#show' do
    it 'should respond with a user' do
      get :show, params: { id: user.id }
      expect(response.body).to have_resource(USER.dup, 'users')
    end
    it 'has status ok' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    context 'without authentication' do
      it 'should not return the password or email' do
        get :show, params: { id: user.id }
        expect(response.body).not_to have_resource({
          password: String,
          email: String
        }, 'users')
      end
    end
  end

  describe '#create' do
    def create_user
      post :create, params: {
        data: {
          type: 'users',
          attributes: {
            name: 'Senjougahara',
            about: 'hitagi crab',
            email: 'senjougahara@hita.gi',
            password: 'headtilt'
          }
        }
      }
    end

    it 'has status created' do
      create_user
      expect(response).to have_http_status(:created)
    end
    it 'should have one more user than before' do
      expect {
        create_user
      }.to change { User.count }.by(1)
    end
    it 'should respond with a user' do
      create_user
      expect(response.body).to have_resource(USER.dup, 'users', singular: true)
    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    def update_user
      sign_in user
      post :update, params: {
        id: user.id,
        data: {
          type: 'users',
          id: user.id,
          attributes: {
            name: 'crab'
          }
        }
      }
    end

    it 'has status ok' do
      update_user
      expect(response).to have_http_status(:ok)
    end
    it 'should update the user' do
      update_user
      user.reload
      expect(user.name).to eq 'crab'
    end
    it 'should respond with a user' do
      update_user
      expect(response.body).to have_resource(USER.dup, 'users', singular: true)
    end
  end

  describe '#confirm' do
    let(:user) { create(:user, confirmed_at: nil) }
    let(:token) do
      Doorkeeper::AccessToken.create(
        resource_owner_id: user.id,
        scopes: 'email_confirm',
        expires_in: 7.days
      )
    end

    context 'with an invalid or missing captcha token' do
      it 'rejects account activation and returns a 400 bad request error' do
        allow(controller).to receive(:valid_captcha?).and_return(false)

        get :confirm, params: { token: token.token, captcha_token: nil }

        expect(response).to have_http_status(:bad_request)
        expect(user.reload.confirmed_at).to be_nil
      end
    end

    context 'with a valid captcha token' do
      it 'successfully activates the user account profile' do
        allow(controller).to receive(:valid_captcha?).and_return(true)

        get :confirm, params: { token: token.token, captcha_token: 'valid_mock_token' }

        expect(response).to have_http_status(:ok)
        expect(user.reload.confirmed_at).not_to be_nil
      end
    end
  end/workspaces/kitsu-server/spec/controllers/users_controller_spec.rb
end

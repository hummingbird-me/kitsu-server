# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  birthday                    :date
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  country                     :string(2)
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  favorites_count             :integer          default(0), not null
#  feed_completed              :boolean          default(FALSE), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  ip_addresses                :inet             default([]), is an Array
#  language                    :string
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  life_spent_on_anime         :integer          default(0), not null
#  likes_given_count           :integer          default(0), not null
#  likes_received_count        :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  password_digest             :string(255)      default(""), not null
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  previous_email              :string
#  pro_expires_at              :datetime
#  profile_completed           :boolean          default(FALSE), not null
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  share_to_global             :boolean          default(TRUE), not null
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  time_zone                   :string
#  title                       :string
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
#  pinned_post_id              :integer
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  twitter_id                  :string
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#  index_users_on_to_follow    (to_follow)
#  index_users_on_waifu_id     (waifu_id)
#
# Foreign Keys
#
#  fk_rails_bc615464bf  (pinned_post_id => posts.id)
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  USER ||= { name: String, pastNames: Array }.freeze
  CURRENT_USER ||= { email: String }.merge(USER).freeze
  let(:user) { create(:user) }

  describe '#index' do
    describe 'with filter[self]' do
      it 'should respond with a user when authenticated' do
        sign_in user
        get :index, filter: { self: 'yes' }
        expect(response.body).to have_resources(CURRENT_USER.dup, 'users')
        expect(response).to have_http_status(:ok)
      end
      it 'should respond with an empty list when unauthenticated' do
        get :index, filter: { self: 'yes' }
        expect(response.body).to have_empty_resource
      end
    end
    describe 'with filter[name]' do
      it 'should find by username' do
        get :index, filter: { name: user.name }
        user_json = USER.merge(name: user.name)
        expect(response.body).to have_resources(user_json, 'users')
      end
    end
  end

  describe '#show' do
    it 'should respond with a user' do
      get :show, id: user.id
      expect(response.body).to have_resource(USER.dup, 'users')
    end
    it 'has status ok' do
      get :show, id: user.id
      expect(response).to have_http_status(:ok)
    end

    context 'without authentication' do
      it 'should not return the password or email' do
        get :show, id: user.id
        expect(response.body).not_to have_resource({
          password: String,
          email: String
        }, 'users')
      end
    end
  end

  describe '#create' do
    def create_user
      post :create, data: {
        type: 'users',
        attributes: {
          name: 'Senjougahara',
          bio: 'hitagi crab',
          email: 'senjougahara@hita.gi',
          password: 'headtilt'
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
      post :update, id: user.id, data: {
        type: 'users',
        id: user.id,
        attributes: {
          name: 'crab'
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
end

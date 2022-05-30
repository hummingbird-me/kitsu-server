require 'rails_helper'

RSpec.describe LibraryEntriesController, type: :controller do
  LIBRARY_ENTRY ||= { status: String, progress: Integer }.freeze
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }

  describe '#index' do
    describe 'with filter[user_id]' do
      it 'responds with a list of library entries' do
        create_list(:library_entry, 3, user: user)
        get :index, params: { filter: { user_id: user } }
        expect(response.body).to have_resources(LIBRARY_ENTRY.dup, 'libraryEntries')
      end
    end

    describe 'with filter[media_type] + filter[media_id]' do
      it 'responds with a list of library entries' do
        create_list(:library_entry, 3, media: anime)
        get :index, params: {
          filter: { media_id: anime.id, media_type: 'Anime' }
        }
        expect(response.body).to have_resources(LIBRARY_ENTRY.dup, 'libraryEntries')
      end
    end

    describe 'with filter[user_id] + filter[media_type] + filter[media_id]' do
      it 'responds with a single library entry as an array' do
        create(:library_entry, user: user, media: anime)
        create_list(:library_entry, 3, user: build(:user), media: anime)
        get :index, params: {
          filter: { media_id: anime.id, media_type: 'Anime', user_id: user }
        }
        expect(response.body).to have_resources(LIBRARY_ENTRY.dup, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end

    describe 'with logged in user' do
      it 'responds with a single private library entry as an array' do
        sign_in(user)
        create(:library_entry, user: user, media: anime, private: true)
        create_list(:library_entry, 3, user: build(:user), media: anime,
          private: true)
        get :index, params: { filter: { user_id: user.id } }
        expect(response.body).to have_resources(LIBRARY_ENTRY.dup, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end

      it 'responds with a list of library entries' do
        sign_in(user)
        create(:library_entry, user: user, media: anime, private: true)
        create_list(:library_entry, 3, user: build(:user), media: anime)
        get :index, params: { filter: { user_id: user.id } }
        expect(response.body).to have_resources(LIBRARY_ENTRY.dup, 'libraryEntries')
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end
  end
end

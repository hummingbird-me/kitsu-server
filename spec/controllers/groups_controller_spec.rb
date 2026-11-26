# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController do
  describe '#index with filter[query]' do
    def search_ids(params = {})
      get :index, params: { filter: { query: 'findable' }, **params }
      JSON.parse(response.body)['data'].map { |found| found['id'].to_i }
    end

    let!(:open) { create(:group, name: 'Findable Open') }
    let!(:closed) { create(:group, name: 'Findable Closed', privacy: :closed) }
    let!(:nsfw) { create(:group, name: 'Findable Lewd', nsfw: true) }

    it 'finds the open, safe-for-work groups for a visitor' do
      expect(search_ids).to eq([open.id])
    end

    it 'also finds closed groups for their members' do
      sign_in create(:group_member, group: closed).user
      expect(search_ids).to contain_exactly(open.id, closed.id)
    end

    it 'also finds NSFW groups for users who opted in' do
      sign_in create(:user, sfw_filter_preference: :nsfw_everywhere)
      expect(search_ids).to contain_exactly(open.id, nsfw.id)
    end

    it 'leaves out a group the index has not caught up on' do
      # Skips the callbacks, so the index still says this group is safe for work
      open.update_columns(nsfw: true) # rubocop:disable Rails/SkipsModelValidations
      expect(search_ids).to be_empty
    end

    it 'applies the privacy filter alongside the query' do
      sign_in create(:group_member, group: closed).user
      expect(search_ids(filter: { query: 'findable', privacy: 'closed' })).to eq([closed.id])
    end
  end
end

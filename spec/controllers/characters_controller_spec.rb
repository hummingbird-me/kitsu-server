# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharactersController do
  describe '#index' do
    describe 'with filter[name]' do
      def search_ids(params = {})
        get :index, params: { filter: { name: 'findable' }, **params }
        JSON.parse(response.body)['data'].map { |found| found['id'].to_i }
      end

      it 'finds characters by name' do
        found = create(:character, name: 'Findable')
        create(:character, name: 'Somebody')
        expect(search_ids).to eq([found.id])
      end

      it 'pages by offset' do
        characters = Array.new(2) { |i| create(:character, name: "Findable #{i}") }
        pages = [0, 1].map { |offset| search_ids(page: { limit: 1, offset: }) }
        expect(pages.flatten).to match_array(characters.map(&:id))
      end
    end
  end
end

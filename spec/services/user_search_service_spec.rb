# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSearchService do
  def search(query)
    described_class.new({ query: [query] }, {})
  end

  it 'finds users by their name' do
    user = create(:user, name: 'Vikhyat')
    create(:user, name: 'Somebody')

    expect(search('vikhyat').to_a).to eq([user])
  end

  it 'finds users by a past name' do
    user = create(:user, name: 'Oldname')
    user.update!(name: 'Newname')

    expect(search('oldname').to_a).to eq([user])
  end

  it 'counts every match, not just the current page' do
    3.times { |i| create(:user, name: "Counted#{i}") }

    expect(search('counted').limit(2).total_count).to eq(3)
  end

  it 'pages through results by offset' do
    users = Array.new(3) { |i| create(:user, name: "Paged#{i}") }

    pages = [0, 2].map { |offset| search('paged').offset(offset).limit(2).to_a }

    expect(pages.flatten).to match_array(users)
  end

  it 'leaves out users who have deleted their account' do
    user = create(:user, name: 'Leaving')
    user.update!(deleted_at: Time.now)

    expect(search('leaving').active.to_a).to be_empty
  end

  describe '#blocking' do
    it 'excludes the given users' do
      blocked = create(:user, name: 'Blocked1')
      visible = create(:user, name: 'Blocked2')

      expect(search('blocked').blocking([blocked.id]).to_a).to eq([visible])
    end

    it 'excludes nobody when given an empty list' do
      user = create(:user, name: 'Unblocked')

      expect(search('unblocked').blocking([]).to_a).to eq([user])
    end
  end
end

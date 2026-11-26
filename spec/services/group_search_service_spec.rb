# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupSearchService do
  def search(query, filters = {})
    described_class.new({ query: [query] }, filters)
  end

  it 'finds groups by their name, tagline or about' do
    by_name = create(:group, name: 'Teapot Club')
    by_tagline = create(:group, name: 'Tagline', tagline: 'We like a teapot')
    by_about = create(:group, name: 'About', about: 'A teapot is short and stout')
    create(:group, name: 'Unrelated')

    expect(search('teapot').to_a).to contain_exactly(by_name, by_tagline, by_about)
  end

  describe '#sfw' do
    it 'excludes NSFW groups' do
      sfw = create(:group, name: 'Kettle Fans')
      create(:group, name: 'Kettle Lewds', nsfw: true)

      expect(search('kettle').sfw.to_a).to eq([sfw])
    end
  end

  describe '#visible_for' do
    let!(:open) { create(:group, name: 'Saucer Open', privacy: :open) }
    let!(:restricted) { create(:group, name: 'Saucer Restricted', privacy: :restricted) }
    let!(:closed) { create(:group, name: 'Saucer Closed', privacy: :closed) }

    it 'hides closed groups from visitors' do
      expect(search('saucer').visible_for(nil).to_a).to contain_exactly(open, restricted)
    end

    it 'hides closed groups from users who are not members' do
      expect(search('saucer').visible_for(create(:user)).to_a)
        .to contain_exactly(open, restricted)
    end

    it 'shows closed groups to their members' do
      member = create(:group_member, group: closed).user

      expect(search('saucer').visible_for(member).to_a)
        .to contain_exactly(open, restricted, closed)
    end
  end

  describe 'filters' do
    it 'filters by privacy' do
      open = create(:group, name: 'Spoon Open', privacy: :open)
      restricted = create(:group, name: 'Spoon Restricted', privacy: :restricted)
      create(:group, name: 'Spoon Closed', privacy: :closed)

      expect(search('spoon', privacy: %w[open restricted]).to_a)
        .to contain_exactly(open, restricted)
    end

    it 'filters by featured' do
      featured = create(:group, name: 'Sugar Featured', featured: true)
      plain = create(:group, name: 'Sugar Plain')

      results = [true, false].map { |value| search('sugar', featured: value).to_a }

      expect(results).to eq([[featured], [plain]])
    end

    it 'filters by category' do
      group = create(:group, name: 'Milk First')
      create(:group, name: 'Milk Last')

      expect(search('milk', category: [group.category]).to_a).to eq([group])
    end

    it 'matches nothing for a category which does not exist' do
      create(:group, name: 'Lemon Slice')

      expect(search('lemon', category: [nil]).to_a).to be_empty
    end
  end

  it 'sorts by last activity' do
    quiet = create(:group, name: 'Biscuit Quiet', last_activity_at: 2.days.ago)
    busy = create(:group, name: 'Biscuit Busy', last_activity_at: 1.hour.ago)

    expect(search('biscuit').order('last_activity_at' => :desc).to_a).to eq([busy, quiet])
  end
end

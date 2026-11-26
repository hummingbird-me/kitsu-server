# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupMembersController do
  describe '#index with the search filters' do
    def member_ids(params)
      get(:index, params:)
      JSON.parse(response.body)['data'].map { |found| found['id'].to_i }
    end

    let(:group) { create(:group) }

    it 'finds the members of a group' do
      member = create(:group_member, group:)
      create(:group_member)
      expect(member_ids(filter: { query_group: group.id })).to eq([member.id])
    end

    it 'finds the memberships of a user' do
      member = create(:group_member)
      create(:group_member)
      expect(member_ids(filter: { query_user: member.user_id })).to eq([member.id])
    end

    it 'finds members by rank' do
      leaders = %i[admin mod].map { |rank| create(:group_member, group:, rank:) }
      create(:group_member, group:)
      expect(member_ids(filter: { query_group: group.id, query_rank: 'admin,mod' }))
        .to match_array(leaders.map(&:id))
    end

    it 'finds memberships by the category of the group' do
      member = create(:group_member, group:)
      create(:group_member)
      expect(member_ids(filter: { group_category: group.category.slug })).to eq([member.id])
    end

    it 'finds memberships by part of the group name' do
      member = create(:group_member, group: create(:group, name: 'The Zyxfind Society'))
      create(:group_member)
      expect(member_ids(filter: { group_name: 'zyxfind' })).to eq([member.id])
    end

    it 'finds members by part of their name' do
      member = create(:group_member, group:, user: create(:user, name: 'TheZyxfinder'))
      create(:group_member, group:)
      expect(member_ids(filter: { query: 'zyxfind' })).to eq([member.id])
    end

    it 'puts the closest name first' do
      far = create(:group_member, group:, user: create(:user, name: 'ZyxfindAndMuchMore'))
      close = create(:group_member, group:, user: create(:user, name: 'Zyxfind'))
      expect(member_ids(filter: { query: 'zyxfind' })).to eq([close.id, far.id])
    end

    it 'sorts as asked instead of by closeness when given a sort' do
      far = create(:group_member, group:, user: create(:user, name: 'ZyxfindAndMuchMore'))
      close = create(:group_member, group:, user: create(:user, name: 'Zyxfind'))
      expect(member_ids(filter: { query: 'zyxfind' }, sort: 'created_at')).to eq([far.id, close.id])
    end

    it 'lists admins first when sorted by rank, as Elasticsearch did' do
      members = %i[pleb admin mod].index_with { |rank| create(:group_member, group:, rank:) }
      expect(member_ids(filter: { query_group: group.id }, sort: 'rank'))
        .to eq(members.values_at(:admin, :mod, :pleb).map(&:id))
    end

    it 'hides the members of closed groups from visitors' do
      create(:group_member, group: create(:group, privacy: :closed, name: 'Zyxfind Hideout'))
      expect(member_ids(filter: { group_name: 'zyxfind' })).to be_empty
    end

    # jsonapi-resources reads the ids of included records from the last table joined, so a filter
    # that joins another table makes it report the wrong group. The ids are forced apart here so
    # that mistake can't pass by coincidence.
    context 'when including the group' do
      def included_group_id(params)
        get(:index, params: { include: 'group', **params })
        JSON.parse(response.body).dig('data', 0, 'relationships', 'group', 'data', 'id').to_i
      end

      it 'reports the right group when searching by member name' do
        user = create(:user, name: 'TheZyxfinder', id: group.id + 1_000_000)
        create(:group_member, group:, user:)
        expect(included_group_id(filter: { query: 'zyxfind' })).to eq(group.id)
      end

      it 'reports the right group when filtering by category' do
        category = create(:group_category)
        group = create(:group, category:, id: category.id + 1_000_000)
        create(:group_member, group:)
        expect(included_group_id(filter: { group_category: category.slug })).to eq(group.id)
      end
    end
  end
end

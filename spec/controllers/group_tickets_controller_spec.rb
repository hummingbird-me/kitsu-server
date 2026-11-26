# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupTicketsController do
  describe '#index with the search filters' do
    def ticket_ids(params)
      get(:index, params:)
      JSON.parse(response.body)['data'].map { |found| found['id'].to_i }
    end

    let(:group) { create(:group) }
    let(:mod) do
      member = create(:group_member, group:)
      create(:group_permission, group_member: member, permission: :tickets)
      member.user
    end

    before { sign_in mod }

    it 'finds the tickets of a group' do
      ticket = create(:group_ticket, group:)
      create(:group_ticket, user: mod)
      expect(ticket_ids(filter: { query_group: group.id })).to eq([ticket.id])
    end

    it 'finds tickets by the name of whoever opened them' do
      ticket = create(:group_ticket, group:, user: create(:user, name: 'TheZyxfinder'))
      create(:group_ticket, group:)
      expect(ticket_ids(filter: { query: 'zyxfind' })).to eq([ticket.id])
    end

    it 'finds tickets by the name of the assignee' do
      ticket = create(:group_ticket, group:, assignee: create(:user, name: 'TheZyxfinder'))
      create(:group_ticket, group:)
      expect(ticket_ids(filter: { query: 'zyxfind' })).to eq([ticket.id])
    end

    it 'finds tickets by the text of a message' do
      ticket = create(:group_ticket, group:)
      create(:group_ticket_message, ticket:, content: 'My zyxfind is broken')
      create(:group_ticket_message, ticket: create(:group_ticket, group:))
      expect(ticket_ids(filter: { query: 'zyxfind' })).to eq([ticket.id])
    end

    it 'does not match mod notes for the person who opened the ticket' do
      ticket = create(:group_ticket, group:)
      create(:group_ticket_message, ticket:, kind: :mod_note, content: 'zyxfind')
      sign_in ticket.user
      expect(ticket_ids(filter: { query: 'zyxfind' })).to be_empty
    end

    it 'applies the other filters alongside the query' do
      zyxfinder = create(:user, name: 'TheZyxfinder')
      resolved = create(:group_ticket, group:, user: zyxfinder, status: :resolved)
      create(:group_ticket, group:, user: zyxfinder)
      expect(ticket_ids(filter: { group: group.id, query: 'zyxfind', status: 'resolved' }))
        .to eq([resolved.id])
    end

    it 'shows the newest matches first' do
      zyxfinder = create(:user, name: 'TheZyxfinder')
      older = create(:group_ticket, group:, user: zyxfinder, created_at: 2.days.ago)
      newer = create(:group_ticket, group:, user: zyxfinder)
      expect(ticket_ids(filter: { query: 'zyxfind' })).to eq([newer.id, older.id])
    end
  end
end

require 'rails_helper'

RSpec.describe HTMLFilters::KitsuMentionFilter do
  def call(text)
    described_class.new(text).call.to_s
  end

  it 'does not do anything fancy for @mention mentions' do
    filter = described_class.new('@mention')
    expect(filter.call.to_s).not_to include('<a')
  end

  context 'with existent user' do
    context 'by slug' do
      let!(:user) { create(:user, slug: 'makoto', name: '菊地真') }
      let(:filter) { described_class.new('@makoto') }

      it 'linkifies mentions' do
        expect(filter.call.to_s).to include('<a')
      end

      it 'adds user ID to mentioned_user list' do
        filter.call
        expect(filter.result[:mentioned_users]).to include(user.id)
      end

      it 'inserts the username into the link' do
        expect(filter.call.to_s).to include(user.name)
      end
    end

    context 'by id' do
      let!(:user) { create(:user, name: 'Mizuki') }
      let(:filter) { described_class.new("@#{user.id}") }

      it 'linkifies mentions' do
        expect(filter.call.to_s).to include('<a')
      end

      it 'adds User ID to mentioned_users list' do
        filter.call
        expect(filter.result[:mentioned_users])
      end

      it 'inserts the username into the link' do
        expect(filter.call.to_s).to include(user.name)
      end
    end
  end

  context 'with nonexistent user' do
    let(:filter) { described_class.new('@fakename') }

    it 'does not linkify mentions' do
      expect(filter.call.to_s).not_to include('<a')
    end

    it 'does not add to mentioned_usernames list' do
      filter.result[:mentioned_users] = []
      expect {
        filter.call
      }.not_to change {
        filter.result[:mentioned_users].count
      }
    end
  end
end

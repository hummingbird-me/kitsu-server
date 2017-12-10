require 'rails_helper'

RSpec.describe HTML::Pipeline::KitsuMentionFilter do
  def call(text)
    described_class.new(text).call.to_s
  end

  it 'should not do anything fancy for @mention mentions' do
    filter = described_class.new('@mention')
    expect(filter.call.to_s).not_to include('<a')
  end

  context 'with existent user' do
    let!(:user) { create(:user, slug: 'thisisatest') }
    let(:filter) { described_class.new('@thisisatest') }

    it 'should linkify mentions' do
      expect(filter.call.to_s).to include('<a')
    end

    it 'should add username to mentioned_usernames list' do
      filter.call
      expect(filter.result[:mentioned_usernames]).to include('thisisatest')
    end
  end

  context 'with nonexistent user' do
    let(:filter) { described_class.new('@fakename') }

    it 'should not linkify mentions' do
      expect(filter.call.to_s).not_to include('<a')
    end

    it 'should not add to mentioned_usernames list' do
      filter.result[:mentioned_usernames] = []
      expect {
        filter.call
      }.not_to change {
        filter.result[:mentioned_usernames].count
      }
    end
  end
end

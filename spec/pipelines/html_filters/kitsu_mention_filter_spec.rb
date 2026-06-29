# encoding: utf-8
require 'rails_helper'

RSpec.describe HTMLFilters::KitsuMentionFilter do
  # The mention filter is a Selma node filter that only inspects text within an
  # element (matching how it runs in a pipeline after Markdown wraps text in
  # block elements), so we wrap the input in a <div> here.
  def run_filter(text, filter = described_class.new)
    Selma::Rewriter.new(sanitizer: nil, handlers: [filter]).rewrite("<div>#{text}</div>")
  end

  it 'should not do anything fancy for @mention mentions' do
    expect(run_filter('@mention')).not_to include('<a')
  end

  context 'with existent user' do
    context 'by slug' do
      let!(:user) { create(:user, slug: 'makoto', name: '菊地真') }
      let(:filter) { described_class.new }

      it 'should linkify mentions' do
        expect(run_filter('@makoto', filter)).to include('<a')
      end

      it 'should add user ID to mentioned_user list' do
        run_filter('@makoto', filter)
        expect(filter.result[:mentioned_users]).to include(user.id)
      end

      it 'should insert the username into the link' do
        expect(run_filter('@makoto', filter)).to include(user.name)
      end
    end

    context 'by id' do
      let!(:user) { create(:user, name: 'Mizuki') }
      let(:filter) { described_class.new }

      it 'should linkify mentions' do
        expect(run_filter("@#{user.id}", filter)).to include('<a')
      end

      it 'should add User ID to mentioned_users list' do
        run_filter("@#{user.id}", filter)
        expect(filter.result[:mentioned_users]).to include(user.id)
      end

      it 'should insert the username into the link' do
        expect(run_filter("@#{user.id}", filter)).to include(user.name)
      end
    end
  end

  context 'with nonexistent user' do
    let(:filter) { described_class.new }

    it 'should not linkify mentions' do
      expect(run_filter('@fakename', filter)).not_to include('<a')
    end

    it 'should not add to mentioned_users list' do
      run_filter('@fakename', filter)
      expect(filter.result[:mentioned_users]).to be_empty
    end
  end
end

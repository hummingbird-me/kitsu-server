require 'rails_helper'

RSpec.describe FeedQueryService do
  let(:user) { build(:user) }

  subject { FeedQueryService.new(params, user) }

  describe '#feed' do
    shared_examples_for 'a feed generator' do |group, id|
      let(:params) do
        {
          'group' => group,
          'id' => id,
          'filters' => { 'kind' => kind }
        }.with_indifferent_access
      end

      context 'when kind is not set' do
        let(:kind) { nil }

        it 'returns the corresponding general feed' do
          expect(subject.feed).to eq(Feed.new(group, id))
        end
      end

      context 'when kind is set to posts' do
        let(:kind) { 'posts' }

        it 'returns the corresponding posts feed' do
          expect(subject.feed).to eq(Feed.new(group, id))
        end
      end

      context 'when kind is set to media' do
        let(:kind) { 'media' }

        it 'returns the corresponding media feed' do
          expect(subject.feed).to eq(Feed.new(group, id))
        end
      end
    end

    context 'when feed is global' do
      it_behaves_like 'a feed generator', 'global', 'global'
    end

    context 'when feed is timeline' do
      it_behaves_like 'a feed generator', 'timeline', '1'
    end

    context 'when feed is user_aggr' do
      it_behaves_like 'a feed generator', 'user_aggr', '1'
    end

    context 'when feed is media_aggr' do
      it_behaves_like 'a feed generator', 'media_aggr', '1'
    end
  end
end

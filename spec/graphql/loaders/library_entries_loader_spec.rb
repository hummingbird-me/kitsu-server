# frozen_string_literal: true

require 'rspec'

RSpec.describe Loaders::LibraryEntriesLoader do
  describe 'sorting by title' do
    let(:user) { create(:user) }
    let(:context) do
      GraphQL::Query::Context.new(query: OpenStruct.new(schema: KitsuSchema), values: nil)
    end
    let(:anime) do
      [
        create(:anime, titles: { zh_cn: '000', en_cn: '111', ja_jp: '222', en: '333' },
          canonical_title: 'zh_cn', romanized_title: 'en_cn', original_title: 'ja_jp'),
        create(:anime, titles: { zh_cn: '111', en_cn: '222', ja_jp: '333', en: '000' },
          canonical_title: 'zh_cn', romanized_title: 'en_cn', original_title: 'ja_jp'),
        create(:anime, titles: { zh_cn: '222', en_cn: '333', ja_jp: '000', en: '111' },
          canonical_title: 'zh_cn', romanized_title: 'en_cn', original_title: 'ja_jp'),
        create(:anime, titles: { zh_cn: '333', en_cn: '000', ja_jp: '111', en: '222' },
          canonical_title: 'zh_cn', romanized_title: 'en_cn', original_title: 'ja_jp')
      ]
    end

    before do
      anime.each do |anime|
        create(:library_entry, user:, media: anime)
      end
    end

    context 'when the user has a preference for romanized titles' do
      it 'sorts by romanized titles' do
        allow(user).to receive(:title_preference_list).and_return(%i[romanized])
        with_current_user(user) do
          nodes = GraphQL::Batch.batch {
            described_class.connection_for({
              find_by: :user_id,
              sort: [{ on: :title, direction: :asc }],
              context:
            }, user.id).nodes
          }.map(&:media_id)
          expect(nodes).to eq([anime[3].id, anime[0].id, anime[1].id, anime[2].id])
        end
      end
    end

    context 'when the user has a preference for translated titles' do
      it 'sorts by translated titles' do
        allow(user).to receive(:title_preference_list).and_return(%i[translated])
        with_current_user(user) do
          nodes = GraphQL::Batch.batch {
            described_class.connection_for({
              find_by: :user_id,
              sort: [{ on: :title, direction: :asc }],
              context:
            }, user.id).nodes
          }.map(&:media_id)
          expect(nodes).to eq([anime[1].id, anime[2].id, anime[3].id, anime[0].id])
        end
      end
    end

    context 'when the user has a preference for canonical titles' do
      it 'sorts by canonical titles' do
        allow(user).to receive(:title_preference_list).and_return(%i[canonical])
        with_current_user(user) do
          nodes = GraphQL::Batch.batch {
            described_class.connection_for({
              find_by: :user_id,
              sort: [{ on: :title, direction: :asc }],
              context:
            }, user.id).nodes
          }.map(&:media_id)
          expect(nodes).to eq([anime[0].id, anime[1].id, anime[2].id, anime[3].id])
        end
      end
    end

    context 'when the user has a preference for original titles' do
      it 'sorts by original titles' do
        allow(user).to receive(:title_preference_list).and_return(%i[original])
        with_current_user(user) do
          nodes = GraphQL::Batch.batch {
            described_class.connection_for({
              find_by: :user_id,
              sort: [{ on: :title, direction: :asc }],
              context:
            }, user.id).nodes
          }.map(&:media_id)
          expect(nodes).to eq([anime[2].id, anime[3].id, anime[0].id, anime[1].id])
        end
      end
    end
  end
end

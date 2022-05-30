# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loaders::SlugLoader do
  context 'with an uppercase slug' do
    let!(:anime) { create(:anime, slug: 'ANIME-TEST') }

    it 'finds with a lowercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('anime-test').then(&:slug)
      end
      expect(slug).to eq('ANIME-TEST')
    end

    it 'finds with an uppercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-TEST').then(&:slug)
      end
      expect(slug).to eq('ANIME-TEST')
    end

    it 'finds with a mixed-case slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-test').then(&:slug)
      end
      expect(slug).to eq('ANIME-TEST')
    end
  end

  context 'with a lowercase slug' do
    let!(:anime) { create(:anime, slug: 'anime-test') }

    it 'finds with a lowercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('anime-test').then(&:slug)
      end
      expect(slug).to eq('anime-test')
    end

    it 'finds with an uppercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-TEST').then(&:slug)
      end
      expect(slug).to eq('anime-test')
    end

    it 'finds with a mixed-case slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-test').then(&:slug)
      end
      expect(slug).to eq('anime-test')
    end
  end

  context 'with a mixed-case slug' do
    let!(:anime) { create(:anime, slug: 'ANIME-test') }

    it 'finds with a lowercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('anime-test').then(&:slug)
      end
      expect(slug).to eq('ANIME-test')
    end

    it 'finds with an uppercase slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-TEST').then(&:slug)
      end
      expect(slug).to eq('ANIME-test')
    end

    it 'finds with a mixed-case slug' do
      slug = GraphQL::Batch.batch do
        Loaders::SlugLoader.for(Anime).load('ANIME-test').then(&:slug)
      end
      expect(slug).to eq('ANIME-test')
    end
  end
end

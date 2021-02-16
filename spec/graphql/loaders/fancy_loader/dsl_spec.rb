# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loaders::FancyLoader::DSL do
  describe '#from' do
    it 'should update the model attribute on the class' do
      klass = Class.new do
        include Loaders::FancyLoader::DSL
        from Anime
      end

      expect(klass.model).to eq(Anime)
    end
  end

  describe '#sort' do
    context 'with no parameters' do
      it 'should add a sort definition with no transform and default column' do
        klass = Class.new do
          include Loaders::FancyLoader::DSL
          from Anime
          sort :episode_count
        end

        defn = klass.sorts[:episode_count]
        expect(defn[:transform]).to eq(nil)
        expect(defn[:column].call).to eq(Anime.arel_table[:episode_count])
      end
    end

    context 'with a transform: parameter' do
      it 'should add a sort definition with the transform proc' do
        transform = ->(arel) { arel }
        klass = Class.new do
          include Loaders::FancyLoader::DSL
          from Anime
          sort :episode_count, transform: transform
        end

        defn = klass.sorts[:episode_count]
        expect(defn[:transform]).to eq(transform)
        expect(defn[:transform]).not_to be_nil
      end
    end

    context 'with an on: parameter' do
      it 'should add a sort definition with the column proc overridden' do
        klass = Class.new do
          include Loaders::FancyLoader::DSL
          from Anime
          sort :newest, on: -> { Anime.arel_table[:created_at] }
        end

        defn = klass.sorts[:newest]
        expect(defn[:column].call).to eq(Anime.arel_table[:created_at])
      end
    end
  end
end

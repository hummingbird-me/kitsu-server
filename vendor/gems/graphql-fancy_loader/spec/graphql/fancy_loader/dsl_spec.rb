# frozen_string_literal: true

RSpec.describe GraphQL::FancyLoader::DSL do
  describe '#from' do
    it 'should update the model attribute on the class' do
      klass = Class.new do
        include GraphQL::FancyLoader::DSL
        from User
      end

      expect(klass.model).to eq(User)
    end
  end

  describe '#sort' do
    context 'with no parameters' do
      it 'should add a sort definition with no transform and default column' do
        klass = Class.new do
          include GraphQL::FancyLoader::DSL
          from Post
          sort :created_at
        end

        defn = klass.sorts[:created_at]
        expect(defn[:transform]).to eq(nil)
        expect(defn[:column].call).to eq(Post.arel_table[:created_at])
      end
    end

    context 'with a transform: parameter' do
      it 'should add a sort definition with the transform proc' do
        transform = ->(arel) { arel }
        klass = Class.new do
          include GraphQL::FancyLoader::DSL
          from Post
          sort :created_at, transform: transform
        end

        defn = klass.sorts[:created_at]
        expect(defn[:transform]).to eq(transform)
        expect(defn[:transform]).not_to be_nil
      end
    end

    context 'with an on: parameter' do
      it 'should add a sort definition with the column proc overridden' do
        klass = Class.new do
          include GraphQL::FancyLoader::DSL
          from Post
          sort :newest, on: -> { Post.arel_table[:created_at] }
        end

        defn = klass.sorts[:newest]
        expect(defn[:column].call).to eq(Post.arel_table[:created_at])
      end
    end
  end

  describe '#modify_query' do
    it 'should update the modify_query_lambda attribute on the class' do
      klass = Class.new do
        include GraphQL::FancyLoader::DSL
        from Post
        modify_query ->(query) { query }
      end

      expect(klass.modify_query_lambda).to be_a(Proc)
    end
  end
end

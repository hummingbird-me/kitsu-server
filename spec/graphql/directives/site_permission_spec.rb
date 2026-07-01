# frozen_string_literal: true

RSpec.describe Directives::SitePermission do
  let(:query_type) do
    Class.new(GraphQL::Schema::Object) do
      graphql_name 'Query'

      field :always_present, String, null: false
    end
  end

  let(:schema) do
    qt = query_type
    Class.new(GraphQL::Schema) do
      query(qt)
      use GraphQL::Schema::Visibility
    end
  end

  it 'does not affect unrelated fields' do
    expect(schema.to_definition).to include('alwaysPresent: String!')
  end

  context 'on a field definition' do
    before do
      query_type.field :needs_permission, String,
        null: false,
        directives: { described_class => { required: 'admin' } }
    end

    context 'for somebody with the required permission' do
      it 'is visible' do
        expect(schema.to_definition(context: { site_permissions: %i[admin] })).to include(
          'needsPermission: String! @sitePermission(required: "admin")'
        )
      end

      it 'executes the field' do
        query_type.define_method(:needs_permission) { 'hello' }
        res = schema.execute('{ needsPermission }', context: { site_permissions: %i[admin] })
        expect(res['data']['needsPermission']).to eq('hello')
      end
    end

    context 'for somebody without the required permission' do
      it 'is hidden' do
        expect(schema.to_definition(context: { site_permissions: [] })).not_to include(
          'needsPermission: String!'
        )
      end

      it 'says the field does not exist' do
        result = schema.execute('{ needsPermission }', context: { site_permissions: [] })
        expect(result['errors'][0]['message']).to eq(
          "Field 'needsPermission' doesn't exist on type 'Query'"
        )
      end

      it 'does not execute the field' do
        executed = false
        query_type.define_method(:needs_permission) { executed = true }
        schema.execute('{ needsPermission }', context: { site_permissions: [] })
        expect(executed).to be false
      end
    end

    context 'for show_all' do
      it 'is visible' do
        expect(schema.to_definition(context: { show_all: true })).to include(
          'needsPermission: String! @sitePermission(required: "admin")'
        )
      end

      it 'does not execute the field' do
        executed = false
        query_type.define_method(:needs_permission) { executed = true }
        schema.execute('{ needsPermission }', context: { show_all: true })
        expect(executed).to be false
      end

      it 'returns an error' do
        query_type.define_method(:needs_permission) { 'test' }
        result = schema.execute('{ needsPermission }', context: { show_all: true })
        expect(result['errors'][0]['message']).to eq(
          'Cannot return null for non-nullable field Query.needsPermission'
        )
      end
    end
  end

  context 'on an object definition' do
    let!(:object) do
      Class.new(GraphQL::Schema::Object) do
        graphql_name 'NeedsPermission'
        field :foo, String, null: false
        def foo = 'bar'
      end
    end

    before do
      object.directive described_class, required: 'admin'
      query_type.field :needs_permission, object, null: false
      query_type.define_method(:needs_permission) { {} }
    end

    context 'for somebody with the required permission' do
      it 'is visible' do
        expect(schema.to_definition(context: { site_permissions: %i[admin] })).to include(
          'type NeedsPermission @sitePermission(required: "admin")'
        )
      end

      it 'executes the field' do
        object.define_method(:foo) { 'baz' }
        res = schema.execute('{ needsPermission { foo } }',
          context: { site_permissions: %i[admin] })
        expect(res['data']['needsPermission']['foo']).to eq('baz')
      end
    end

    context 'for somebody without the required permission' do
      it 'is hidden' do
        expect(schema.to_definition(context: { site_permissions: [] })).not_to include(
          'type NeedsPermission'
        )
      end

      it 'says the field does not exist' do
        result = schema.execute('{ needsPermission { foo } }', context: { site_permissions: [] })
        expect(result['errors'][0]['message']).to eq(
          "Field 'needsPermission' doesn't exist on type 'Query'"
        )
      end
    end

    context 'for show_all' do
      it 'is visible' do
        expect(schema.to_definition(context: { show_all: true })).to include(
          'type NeedsPermission @sitePermission(required: "admin")'
        )
      end

      it 'does not execute the field' do
        executed = false
        object.define_method(:foo) { executed = true }
        schema.execute('{ needsPermission { foo } }', context: { show_all: true })
        expect(executed).to be false
      end

      it 'returns an error' do
        object.define_method(:foo) { 'test' }
        result = schema.execute('{ needsPermission { foo } }', context: { show_all: true })
        expect(result['errors'][0]['message']).to eq(
          'Cannot return null for non-nullable field Query.needsPermission'
        )
      end
    end
  end

  context 'on a mutation definition' do
    let!(:object) do
      Class.new(GraphQL::Schema::Mutation) do
        graphql_name 'NeedsPermission'

        field :foo, String, null: false

        def resolve = { foo: 'baz' }
      end
    end

    before do
      object.directive described_class, required: 'admin'
      query_type.field :needs_permission, mutation: object, null: false
    end

    context 'for somebody with the required permission' do
      it 'is visible' do
        expect(schema.to_definition(context: { site_permissions: %i[admin] })).to include(
          'needsPermission: NeedsPermissionPayload! @sitePermission(required: "admin")'
        )
      end

      it 'executes the field' do
        res = schema.execute('{ needsPermission { foo } }',
          context: { site_permissions: %i[admin] })

        pp res
        expect(res['data']['needsPermission']['foo']).to eq('baz')
      end
    end

    context 'for somebody without the required permission' do
      it 'is hidden' do
        expect(schema.to_definition(context: { site_permissions: [] })).not_to include(
          'needsPermission: NeedsPermissionPayload!'
        )
      end

      it 'says the field does not exist' do
        result = schema.execute('{ needsPermission { foo } }', context: { site_permissions: [] })
        expect(result['errors'][0]['message']).to eq(
          "Field 'needsPermission' doesn't exist on type 'Query'"
        )
      end
    end

    context 'for show_all' do
      it 'is visible' do
        expect(schema.to_definition(context: { show_all: true })).to include(
          'needsPermission: NeedsPermissionPayload! @sitePermission(required: "admin")'
        )
      end

      it 'does not execute the field' do
        executed = false
        object.define_method(:foo) { executed = true }
        schema.execute('{ needsPermission { foo } }', context: { show_all: true })
        expect(executed).to be false
      end

      it 'returns an error' do
        object.define_method(:foo) { 'test' }
        result = schema.execute('{ needsPermission { foo } }', context: { show_all: true })
        expect(result['errors'][0]['message']).to eq(
          'Cannot return null for non-nullable field Query.needsPermission'
        )
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe FancyMutation do
  it 'does not expose the private class methods' do
    mutation = Class.new { include FancyMutation }.new

    expect(mutation).not_to respond_to(:errors_union)
    expect(mutation).not_to respond_to(:warnings_union)
    expect(mutation).not_to respond_to(:input_type)
  end

  describe '#ready?' do
    context 'with no errors added' do
      it 'passes out the return value' do
        mutation = Class.new do
          include FancyMutation

          def ready?(**)
            true
          end
        end

        result = mutation.new.ready?(input: {})
        expect(result).to be(true)
      end
    end

    context 'with errors added' do
      it 'returns the errors in an object' do
        mutation = Class.new do
          include FancyMutation

          def ready?(**)
            errors << 'test'
          end
        end

        result = mutation.new.ready?(input: {})
        expect(result).to eq([false, { errors: ['test'] }])
      end
    end

    context 'with a raised exception' do
      it 'returns the error' do
        mutation = Class.new do
          include FancyMutation

          def ready?(**)
            raise Types::Errors::Base
          end
        end

        result = mutation.new.ready?(input: {})
        expect(result).to eq([
          false,
          { errors: [{ __type: Types::Errors::Base }] }
        ])
      end
    end
  end

  describe '#authorized?' do
    context 'with no errors added' do
      it 'passes out the return value' do
        mutation = Class.new do
          include FancyMutation

          def authorized?(**)
            [true, 'test']
          end
        end

        result = mutation.new.authorized?(input: {})
        expect(result).to eq([true, 'test'])
      end
    end

    context 'with errors added' do
      it 'returns the errors in an object' do
        mutation = Class.new do
          include FancyMutation

          def authorized?(**)
            errors << 'test'
          end
        end

        result = mutation.new.authorized?(input: {})
        expect(result).to eq([false, { errors: ['test'] }])
      end
    end

    context 'with a raised exception' do
      it 'returns the error' do
        mutation = Class.new do
          include FancyMutation

          def authorized?(**)
            raise Types::Errors::Base
          end
        end

        result = mutation.new.authorized?(input: {})
        expect(result).to eq([
          false,
          { errors: [{ __type: Types::Errors::Base }] }
        ])
      end
    end
  end

  describe '.result' do
    it 'creates a field named "result" with the provided type' do
      result_type = Class.new(Types::BaseObject) do
        graphql_name 'TestResult'
      end
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        result result_type
      end

      expect(mutation.fields['result'].type.graphql_name).to eq('TestResult')
    end

    it 'passes through any arguments to the field' do
      result_type = Class.new(Types::BaseObject) do
        graphql_name 'TestResult'
      end
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        result result_type, description: '__testing__'
      end

      expect(mutation.fields['result'].description).to eq('__testing__')
    end
  end

  describe '.input' do
    it 'creates a field named "input" with a generated, required input type' do
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        input {} # rubocop:disable Lint/EmptyBlock
      end

      expect(mutation.arguments['input'].type).to be_a(GraphQL::Schema::NonNull)
      expect(mutation.arguments['input'].type.of_type.graphql_name).to eq('TestMutationInput')
    end

    it 'allows setting arguments on the input type' do
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        input do
          argument :test, String, required: true
        end
      end
      input_arguments = mutation.arguments['input'].type.of_type.arguments

      expect(input_arguments).to have_key('test')
    end

    it 'can be called multiple times to add arguments to the input type' do
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        input do
          argument :test_a, String, required: true
        end

        input do
          argument :test_b, String, required: true
        end
      end
      input_arguments = mutation.arguments['input'].type.of_type.arguments

      expect(input_arguments).to have_key('testA')
      expect(input_arguments).to have_key('testB')
    end
  end

  describe '.errors' do
    it 'adds an errors field of type [union!]' do
      error_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        errors error_type
      end

      expect(mutation.fields).to have_key('errors')
      errors_union = mutation.fields['errors'].type.of_type.of_type
      expect(errors_union.graphql_name).to eq('TestMutationErrorsUnion')
    end

    it 'adds the provided types to the union type' do
      error_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        errors error_type
      end
      error_types = mutation.fields['errors'].type.of_type.of_type.possible_types

      expect(error_types).to include(error_type)
    end

    it 'can be called multiple times to add to the union' do
      error_type_a = Class.new(Types::BaseObject)
      error_type_b = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        errors error_type_a
        errors error_type_b
      end
      error_types = mutation.fields['errors'].type.of_type.of_type.possible_types

      expect(error_types).to include(error_type_a)
      expect(error_types).to include(error_type_b)
    end

    it 'resolves the union type based on the __type key' do
      error_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        errors error_type
      end
      error_union = mutation.fields['errors'].type.of_type.of_type
      resolved_type = error_union.resolve_type({ __type: error_type }, {})

      expect(resolved_type).to eq(error_type)
    end
  end

  describe '.warnings' do
    it 'adds a warnings field of type [union!]' do
      warning_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings warning_type
      end

      expect(mutation.fields).to have_key('warnings')
      warnings_union = mutation.fields['warnings'].type.of_type.of_type
      expect(warnings_union.graphql_name).to eq('TestMutationWarningsUnion')
    end

    it 'adds an ignore_warnings argument to the input type' do
      warning_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings warning_type
      end
      input_type = mutation.arguments['input'].type.of_type

      expect(input_type.arguments).to have_key('ignoreWarnings')
      expect(input_type.arguments['ignoreWarnings'].type).to eq(GraphQL::Types::Boolean)
    end

    it 'adds the provided types to the union type' do
      warning_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings warning_type
      end
      warning_types = mutation.fields['warnings'].type.of_type.of_type.possible_types

      expect(warning_types).to include(warning_type)
    end

    it 'can be called multiple times to add to the union' do
      warning_type_a = Class.new(Types::BaseObject)
      warning_type_b = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings warning_type_a
        warnings warning_type_b
      end
      warning_types = mutation.fields['warnings'].type.of_type.of_type.possible_types

      expect(warning_types).to include(warning_type_a)
      expect(warning_types).to include(warning_type_b)
    end

    it 'resolves the union type based on the __type key' do
      warning_type = Class.new(Types::BaseObject)
      mutation = Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings warning_type
      end
      warning_union = mutation.fields['warnings'].type.of_type.of_type
      resolved_type = warning_union.resolve_type({ __type: warning_type }, {})

      expect(resolved_type).to eq(warning_type)
    end
  end

  describe '#resolve_with_support' do
    let(:test_warning) do
      Class.new(Types::BaseObject) do
        graphql_name 'TestWarning'
      end
    end
    let(:mutation) do
      test_warning = self.test_warning
      Class.new(Mutations::Base) do
        graphql_name 'TestMutation'
        include FancyMutation

        warnings test_warning
        errors Types::Errors::NotAuthenticated
        result String
      end
    end
    let(:mutation_type) do
      mutation = self.mutation
      Class.new(Types::BaseObject) do
        graphql_name 'TestMutationSchema'
        field :test, mutation:
      end
    end
    let(:schema) do
      mutation_type = self.mutation_type
      Class.new(GraphQL::Schema) do
        mutation mutation_type
      end
    end

    context 'when the result is the same as the errors list' do
      it 'returns the result as nil' do
        mutation.define_method(:resolve) do |*_|
          errors << Types::Errors::NotAuthenticated.build
        end

        response = schema.execute(<<~GRAPHQL).dig('data', 'test')
          mutation {
            test(input: {}) {
              result
            }
          }
        GRAPHQL

        expect(response['result']).to be_nil
      end
    end

    context 'when warnings are present' do
      context 'and ignore_warnings is false or not present' do
        it 'rolls back the transaction' do
          test_warning = self.test_warning
          mutation.define_method(:resolve) do |*_|
            warnings << { __type: test_warning }
            FactoryBot.create(:anime)
          end

          expect {
            schema.execute(<<~GRAPHQL)
              mutation {
                test(input: {}) { }
              }
            GRAPHQL
          }.not_to change(Anime, :count)
        end

        it 'returns the warnings as a field' do
          test_warning = self.test_warning
          mutation.define_method(:resolve) do |*_|
            warnings << { __type: test_warning }
          end

          response = schema.execute(<<~GRAPHQL).dig('data', 'test')
            mutation {
              test(input: {}) {
                warnings {
                  __typename
                }
              }
            }
          GRAPHQL

          expect(response['warnings']).to include({ '__typename' => 'TestWarning' })
        end

        it 'adds a WarningsPresent error' do
          test_warning = self.test_warning
          mutation.define_method(:resolve) do |*_|
            warnings << { __type: test_warning }
          end

          response = schema.execute(<<~GRAPHQL).dig('data', 'test')
            mutation {
              test(input: {}) {
                errors {
                  __typename
                }
              }
            }
          GRAPHQL

          expect(response['errors']).to include({ '__typename' => 'WarningsPresentError' })
        end

        it 'makes the result nil' do
          test_warning = self.test_warning
          mutation.define_method(:resolve) do |*_|
            warnings << { __type: test_warning }
            'test'
          end

          response = schema.execute(<<~GRAPHQL).dig('data', 'test')
            mutation {
              test(input: {}) {
                result
              }
            }
          GRAPHQL

          expect(response['result']).to be_nil
        end
      end
    end
  end

  describe '#authenticate!' do
    it 'raises an ErrorWrapper<NotAuthenticated> if the user is not authenticated' do
      mutation = Struct.new(:current_user) do
        include FancyMutation
      end

      instance = mutation.new(nil)
      expect {
        instance.authenticate!
      }.to raise_error(satisfying do |error|
        expect(error).to be_a(FancyMutation::ErrorWrapper)
        expect(error.error).to include(Types::Errors::NotAuthenticated.build)
      end)
    end

    it 'returns true otherwise' do
      mutation = Struct.new(:current_user) do
        include FancyMutation
      end

      result = mutation.new(true).authenticate!
      expect(result).to eq(true)
    end
  end

  describe '#authorize!' do
    context 'without an explicit policy' do
      it "checks the action on the object's implicit policy" do
        policy = instance_spy('AnimePolicy')
        policy_class = class_double('AnimePolicyClass', new: policy)
        stub_const('AnimePolicy', policy_class)
        mutation = Struct.new(:current_token) do
          include FancyMutation
        end

        mutation.new(nil).authorize!(Anime.new, :create?)
        expect(policy).to have_received(:create?)
      end
    end

    context 'with an explicit policy' do
      it 'raises an ErrorWrapper<NotAuthorized> error if the policy rejects it' do
        policy = instance_double('AnimePolicy', create?: false)
        policy_class = class_double('AnimePolicyClass', new: policy)
        mutation = Struct.new(:current_token) do
          include FancyMutation
        end

        instance = mutation.new(nil)
        expect {
          instance.authorize!(Anime.new, :create?, policy: policy_class)
        }.to raise_error(satisfying do |error|
          expect(error).to be_a(FancyMutation::ErrorWrapper)
          expect(error.error).to include(Types::Errors::NotAuthorized.build)
        end)
      end
    end
  end

  describe '#resolve' do
    context 'with a raised exception' do
      it 'returns the error' do
        mutation = Class.new do
          include FancyMutation

          def resolve(**)
            raise Types::Errors::Base
          end
        end

        result = mutation.new.resolve(input: {})
        expect(result).to eq({
          errors: [{ __type: Types::Errors::Base }]
        })
      end
    end
  end
end

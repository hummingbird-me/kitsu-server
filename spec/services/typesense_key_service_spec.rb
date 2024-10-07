# frozen_string_literal: true

RSpec.describe TypesenseKeyService do
  let(:index) do
    TypesenseAnimeIndex.tap do |index|
      allow(index).to receive(:search_key).and_return('xyz')
    end
  end

  let(:model) do
    double(typesense_index: index)
  end

  let(:scope) do
    Class.new(ApplicationPolicy::TypesensualScope) do
      def resolve
        @search.filter(foo: 'bar')
      end
    end
  end

  let(:policy) do
    # Resolve TypesensualScope in the context of the policy
    Class.new(ApplicationPolicy).tap do |klass|
      klass::TypesensualScope = scope
    end
  end

  before do
    finder = class_double(Pundit::PolicyFinder).as_stubbed_const
    allow(finder).to receive_message_chain(:new, :policy).and_return(policy)
  end

  describe '#key' do
    it 'returns a key scoped to the resolved search filters' do
      key = described_class.new(model, nil).key
      payload = Base64.decode64(key)
      expect(payload).to end_with('xyz{"filter_by":"foo:bar"}')
    end
  end
end

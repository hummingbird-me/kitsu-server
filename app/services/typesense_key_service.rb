# frozen_string_literal: true

class TypesenseKeyService
  delegate :search_key, to: :@index

  def initialize(model, token)
    @model = model
    @token = token
    @index = model.typesense_index
  end

  def key
    @key ||= Typesensual.client.keys.generate_scoped_search_key(
      search_key,
      scope.query.except(:collection).compact_blank
    )
  end

  def scope
    return @scope if @scope
    policy = Pundit::PolicyFinder.new(@model).policy
    search = @index.search(query: nil, query_by: nil)
    @scope = policy::TypesensualScope.new(@token, search).resolve
  rescue NameError
    search
  end
end

class AlgoliaGraphqlSearchService
  def initialize(model, token)
    @model = model
    @index = model.algolia_index.safe_constantize
    @token = token
  end

  def search(query, restrict_searchable_attributes: nil, filters: nil, **opts)
    opts[:filters] = scoped_filters(filters)
    opts[:restrictSearchableAttributes] = restrict_searchable_attributes

    @index.search(query, opts.compact)
  end

  def scope
    return @scope if @scope
    policy = Pundit::PolicyFinder.new(@model).policy
    @scope = policy::AlgoliaScope.new(@token).resolve
  rescue NameError
    ''
  end

  private

  def scoped_filters(filters)
    return filters if scope.blank?
    # if there are no filters supplied, just return the scope
    return scope if filters.blank?

    "#{filters} AND #{scope}"
  end
end

# frozen_string_literal: true

class AlgoliaGraphqlSearchService
  def initialize(model, token)
    @model = model
    @index = model.algolia_index.safe_constantize
    @token = token
  end

  def search(query, restrict_searchable_attributes: nil, filters: nil, **opts)
    opts[:filters] = filters if filters.present?
    opts[:restrict_searchable_attributes] = format_attributes(restrict_searchable_attributes)

    @index.search(query, opts.compact)
  end

  private

  def format_attributes(attributes)
    attributes.map { |attribute| attribute.camelize(:lower) }
  end
end

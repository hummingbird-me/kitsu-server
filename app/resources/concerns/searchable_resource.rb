# frozen_string_literal: true

module SearchableResource
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :_chewy_index, :_query_fields, :_search_service

    # Declare the Chewy index to use when searching this resource
    def index(index)
      @_chewy_index = index
    end

    def search_with(service)
      @_search_service = service
    end

    def inherited(subclass)
      subclass.instance_variable_set(:@_chewy_index, @_chewy_index)
      subclass.instance_variable_set(:@_search_service, @_search_service)
      subclass.instance_variable_set(:@_query_fields, @_query_fields.deep_dup)
      super
    end

    # Declare the fields to query, and how to query them
    def query(field, opts = {})
      field = field.to_sym

      # For some reason, #filter(verify:) is supposed to return the values to
      # use.  I cannot honestly figure out why this is the case, so we provide
      # #query(valid:) instead.  #query(valid:) lambdas receive a value+context
      # and return a boolean.  If all values in a field are valid, the whole
      # is assumed valid.
      #
      # If you must, you can still use #filter(verify:) to handle the entire
      # array all at once, or to modify values.
      filter field, verify: opts[:verify] || ->(values, context) do
        if opts[:valid]
          values if values.all? { |v| opts[:valid].call(v, context) }
        else
          values
        end
      end

      @_query_fields ||= {}
      @_query_fields[field] = opts
    end

    # Determine if an ElasticSearch hit is required
    def should_query?(filters)
      return false unless filters.respond_to?(:keys)
      return false unless @_query_fields
      filters.keys.any? { |key| @_query_fields.include?(key) }
    end

    def find(filters, options = {})
      return super(filters, options) unless should_query?(filters)

      resources_for(find_records(filters, options), options[:context])
    end

    def find_fragments(filters, opts = {})
      return super(filters, opts) unless should_query?(filters)

      build_resource_fragments(find_records(filters, opts), opts)
    end

    def count(filters, opts = {})
      return super(filters, opts) unless should_query?(filters)
      return 0 if filters.values.any?(&:nil?)

      apply_scopes(filters, opts).total_count
    end

    # Compatibility helper for app code which still needs the old relation.
    def find_records(filters, opts = {})
      filters ||= {}
      return records_for_filters(filters, opts) unless should_query?(filters)
      return [] if filters.values.any?(&:nil?)

      # Apply scopes and load
      load_query_records(apply_scopes(filters, opts), opts)
    end

    def load_query_records(query, _opts = {})
      _search_service ? query.to_a : query.load.to_a
    end

    # Count all search results
    def find_count(filters, opts = {})
      count(filters, opts)
    end

    # Allow sorting on anything queryable + _score
    def sortable_fields(context = nil)
      @_query_fields ||= {}
      if searchable?
        super(context) + @_query_fields.keys + ['_score']
      else
        super(context)
      end
    end

    def searchable?
      @_query_fields.present?
    end

    private

    def records_for_filters(filters, opts = {})
      sort_criteria = opts[:sort_criteria] || []
      join_manager = JSONAPI::ActiveRelation::JoinManager.new(
        resource_klass: self,
        filters:,
        sort_criteria:
      )

      apply_request_settings_to_records(
        records: records(opts),
        filters:,
        sort_criteria:,
        paginator: opts[:paginator],
        join_manager:,
        options: opts
      )
    end

    def build_resource_fragments(records, opts = {})
      records.each_with_object({}) do |record, fragments|
        next if record.nil?

        resource_klass = resource_klass_for_model(record)
        id = record.public_send(resource_klass._primary_key)
        next if id.nil?

        identity = JSONAPI::ResourceIdentity.new(resource_klass, id)
        fragment = JSONAPI::ResourceFragment.new(identity)

        add_fragment_cache(fragment, resource_klass, record) if opts[:cache]
        add_fragment_attributes(fragment, resource_klass, record, opts[:attributes])

        fragments[identity] = fragment
      end
    end

    def add_fragment_cache(fragment, resource_klass, record)
      cache_field = resource_klass.attribute_to_model_field(:_cache_field)
      return unless record.respond_to?(cache_field[:name])

      fragment.cache = cast_fragment_value(
        resource_klass,
        record.public_send(cache_field[:name]),
        cache_field[:type]
      )
    end

    def add_fragment_attributes(fragment, resource_klass, record, attributes)
      Array.wrap(attributes).each do |attribute|
        model_field = resource_klass.attribute_to_model_field(attribute)
        next unless record.respond_to?(model_field[:name])

        fragment.add_attribute(
          attribute,
          cast_fragment_value(
            resource_klass,
            record.public_send(model_field[:name]),
            model_field[:type]
          )
        )
      end
    end

    def cast_fragment_value(resource_klass, value, type)
      type ? resource_klass.cast_to_attribute_type(value, type) : value
    end

    def apply_scopes(filters, opts = {})
      context = opts[:context]
      if _search_service
        # Separate queries from filters
        queries = filters.select { |f| @_query_fields.include?(f) }
        filters = filters.reject { |f| @_query_fields.include?(f) }
        # Set up the search service
        query = _search_service.new(queries, filters)
      else
        # Generate query
        query = generate_query(filters)
        query = query.reduce(@_chewy_index) do |scope, subquery|
          scope.public_send(*subquery.values_at(:mode, :query))
        end
      end
      # Pagination
      query = opts[:paginator].apply(query, {}) if opts[:paginator]
      # Sorting
      query = if opts[:sort_criteria]
        opts[:sort_criteria].reduce(query) do |scope, sort|
          field = sort[:field] == 'id' ? '_score' : sort[:field]
          scope.order(field => sort[:direction])
        end
      else
        query.order('_score' => :desc)
      end
      # Policy Scope
      query = search_policy_scope.new(context[:current_user], query).resolve
      context[:policy_used]&.call

      query
    end

    def search_policy_scope
      Pundit::PolicyFinder.new(_model_class.new).scope!
    end

    def generate_query(filters)
      # For each queryable field, attempt to apply.  If there's no apply
      # specified, use auto_query to generate one.
      queries = @_query_fields.map do |field, opts|
        next unless filters.key?(field) # Skip if we don't have a filter

        filter = filters[field]
        filter = opts[:apply].call(filter, {}) if opts[:apply]

        { mode: opts[:mode] || :filter, query: auto_query(field, filter) }
      end
      queries.compact
    end

    def auto_query(field, value)
      case value
      when String, Integer, Float, Date
        { match: { field => value } }
      when Range
        { range: { field => { gte: value.min, lte: value.max } } }
      when Array
        # Array<String|Fixnum|Float> get shorthanded to a single match query
        if value.all? { |v| v.is_a?(String) || v.is_a?(Numeric) }
          auto_query(field, value.join(' '))
        else
          matchers = value.map { |v| auto_query(field, v) }
          { bool: { should: matchers } }
        end
      when Hash
        value.deep_transform_keys { |key| key.to_s == '$field' ? field : key }
      else
        value
      end
    end
  end
end

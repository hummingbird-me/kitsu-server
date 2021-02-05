class BaseIndex
  class_attribute :_attributes, :_index, :_associations
  attr_reader :_model, :_new, :_associated

  class << self
    def attribute(*names, frequency: nil, format: nil)
      self._attributes ||= []
      self._attributes += names.map do |name|
        { name: name.to_s, frequency: frequency, format: format }
      end
    end
    alias_method :attributes, :attribute

    # rubocop:disable Style/PredicateName, Naming/UncommunicativeMethodParamName
    def has_many(name, as:, via: name, polymorphic: false)
      self._associations ||= []
      self._associations << {
        attr: as,
        association: via,
        name: name,
        plurality: :many,
        polymorphic: polymorphic
      }
    end

    def has_one(name, as:, via: name, polymorphic: false)
      self._associations ||= []
      self._associations << {
        attr: as,
        association: via,
        name: name,
        plurality: :one,
        polymorphic: polymorphic
      }
    end
    # rubocop:enable Style/PredicateName, Naming/UncommunicativeMethodParamName

    def _association_names
      @_association_names ||= self._associations.map { |assoc| assoc[:name] }
      return [] unless self._associations
    end

    def _singular_associations
      return [] unless _associations
      @_singular_associations ||= _associations.select do |assoc|
        assoc[:plurality] == :one && assoc[:polymorphic] == false
      end
    end

    def _attribute_names
      @_names ||= self._attributes.map { |attr| attr[:name] }
    end

    def index_name
      "#{Rails.env}_#{_index}"
    end

    def index_name=(value)
      @_index = nil
      self._index = value
    end

    def search(query, opts = {})
      formatted_opts = opts.deep_transform_keys { |key| key.to_s.camelize(:lower) }

      hits = index.search(query, formatted_opts)['hits']
      result_ids = hits.each_with_object({}) do |value, acc|
        acc[value['kind']] ||= []
        acc[value['kind']] << value['id']
      end
      results = result_ids.map { |kind, ids|
        [kind, kind.classify.safe_constantize.where(id: ids).index_by(&:id)]
      }.to_h
      hits.map { |hit| results.dig(hit['kind'], hit['id']) }.compact
    end

    def index
      @_index ||= Algolia::Index.new(index_name)
    end

    def inherited(subclass)
      if subclass.name && !subclass._index
        self.index_name = subclass.name.sub(/Index\z/, '').underscore
      end
      super
    end

    def index!(model)
      return if Rails.env.development?
      model.in_batches do |group|
        associated = associated_for(group)
        serialized = group.map { |record| new(record, associated: associated[record.id]).as_json }
        index.add_objects(serialized)
      end
    end

    def associated_for(records)
      fast_associated_for(records).deep_merge(slow_associated_for(records))
    end

    def missing_associations_for(model)
      return [] unless _associations
      _associations.select { |assoc| target_association_for(model, assoc[:association]).nil? }
    end

    ### Fast path (direct monomorphic associations we can pluck)

    # Returns a list of associations which can take the fastpath via SQL bulk loading
    def fast_associations_for(model)
      return [] unless _associations
      (_associations - missing_associations_for(model)).reject do |assoc|
        target_association_for(model, assoc[:association]).options[:polymorphic]
      end
    end

    # Get all the associations that can be loaded via high-speed plucking
    def fast_associated_for(records)
      # Get the model
      model = records.model
      # Get the associations which apply to this model
      associations = fast_associations_for(model)
      # Generate the output hash keys
      association_keys = associations.map { |assoc| assoc[:name].to_sym }
      # Generate the joins hash
      joins_hash = joins_hash_for(associations.map { |x| x[:association] })
      # Generate the pluck string
      plucks = Arel.sql(pluck_for_associations(model, associations))

      # Add the joins, group by the ID, pluck the data
      data = records.eager_load(joins_hash).group(Arel.sql("#{model.table_name}.id")).pluck(plucks)
      # For each row like [id, assoc, assoc, assoc, assoc, ...]
      data.map { |(id, *values)|
        # Zip it up into [id, assoc_name => assoc, assoc_name => assoc, ...] and compact the data
        associated = association_keys.zip(values).to_h.transform_values(&:compact)
        # For has_one associations, drop later values
        _singular_associations.each do |assoc|
          associated[assoc[:name]] = associated[assoc[:name]].first
        end
        [id, associated]
      }.to_h
    end

    # Generate the array_agg() select for this association+column
    def select_for_association(association, column)
      return unless association
      "array_agg(DISTINCT #{association.table_name}.#{column})"
    end

    # Build the
    def pluck_for_associations(model, associations)
      <<-PLUCK
        #{model.table_name}.id#{',' unless associations.empty?}
        #{associations.map { |assoc|
          select_for_association(target_association_for(model, assoc[:association]), assoc[:attr])
        }.compact.join(', ')}
      PLUCK
    end

    ### Slow path (loading with Rails eager loading, traversal with methods)

    # Get the associations which need to be loaded with the slowpath
    def slow_associations_for(model)
      return [] unless _associations
      _associations - missing_associations_for(model) - fast_associations_for(model)
    end

    # Loads associated data through the slowpath, by building an inclusion hash and then traversing
    # through method calls.
    def slow_associated_for(records)
      associations = slow_associations_for(records.model)
      includes_hash = joins_hash_for(associations.map { |x| x[:association] })

      records.includes(includes_hash).each_with_object({}) do |record, out|
        out[record.id] = associations.each_with_object({}) do |assoc, associated|
          path = assoc[:association].to_s.split('.').map(&:to_sym)
          value = path.reduce(record) do |acc, key|
            if acc.respond_to?(key)
              acc.send(key)
            else
              acc.map { |x| x.send(key) }
            end
          end
          value = if value.respond_to?(assoc[:attr])
                    value.send(assoc[:attr])
                  elsif value.respond_to?(:map)
                    value.map { |x| x.send(assoc[:attr]) }
                  end
          associated[assoc[:name]] = value
        end
      end
    end

    # Traverses the graph of ActiveRecord model reflections, taking a dot.separated.list and
    # returning the final target association that it refers to
    # @param base [ActiveRecord::Base] the starting point for traversal
    # @param key [String,#to_s] the dot-separated reference to the association
    def target_association_for(base, key)
      key.to_s.split('.').reduce(base) do |acc, k|
        acc = acc.klass if acc.is_a? ActiveRecord::Reflection::AbstractReflection
        return nil unless acc.reflections[k]
        acc.reflections[k]
      end
    end

    # Generates the hash for passing to joins/includes/eager_load
    def joins_hash_for(*keys)
      keys.flatten.each_with_object({}) do |key, acc|
        key_parts = key.to_s.split('.').map!(&:to_sym)
        key_parts.reduce(acc) do |hash, elem|
          hash[elem] ||= {}
        end
      end
    end
  end

  delegate :index, to: :class

  def initialize(model, new: true, associated: nil)
    @_model = model
    @_new = new
    @_associated = associated || load_associated
  end

  def load_associated
    return if Rails.env.development?

    self.class.associated_for(_model.class.where(id: _model.id))[_model.id]
  end

  def _attribute_names
    @_attribute_names ||= self.class._attribute_names.select { |m| _model.respond_to?(m) }
  end

  def _attributes
    set = Set.new(_attribute_names)
    self.class._attributes.select { |attr| set.include?(attr[:name]) }
  end

  def dirty?
    _attributes.each do |attr|
      changed = "#{attr[:name]}_changed?"
      puts attr[:name]
      dirty = if respond_to?(changed) then send(changed)
              elsif _model.respond_to?(changed) then _model.send(changed)
              else true
              end
      dirty &&= rand(100.0) <= attr[:frequency] if attr[:frequency]
      return true if dirty
    end

    false
  end

  def save!
    return if Rails.env.development?

    if _new || model.new_record?
      index.add_object(as_json)
    elsif model.destroyed?
      index.delete_object(algolia_id)
    elsif dirty?
      index.save_object(as_json)
    end
  rescue Algolia::AlgoliaError
    false
  end

  def algolia_id
    "#{_model.class.table_name}_#{_model.id}"
  end

  def base_attributes
    {
      kind: _model.class.name.underscore.dasherize,
      id: _model.id,
      objectID: algolia_id,
      _tags: [algolia_id]
    }
  end

  def as_json(*)
    res = _attributes.each_with_object({}) do |attr, acc|
      value = respond_to?(attr[:name]) ? send(attr[:name]) : _model.send(attr[:name])
      acc[attr[:name]] = attr[:format] ? attr[:format].format(value) : value
    end
    res.merge!(_associated) if _associated
    res.transform_keys! { |k| k.to_s.camelize(:lower) }
    res.merge!(base_attributes)
    res
  end
end

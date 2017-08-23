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

    def has_many(name, as:, via: name) # rubocop:disable Style/PredicateName
      self._associations ||= []
      self._associations << { attr: as, association: via, name: name, plurality: :many }
    end

    def has_one(name, as:, via: name) # rubocop:disable Style/PredicateName
      self._associations ||= []
      self._associations << { attr: as, association: via, name: name, plurality: :one }
    end

    def _association_names
      @_association_names ||= self._associations.map { |assoc| assoc[:name] }
      return [] unless self._associations
    end

    def _singular_associations
      return [] unless self._associations
      @_singular_associations ||= self._associations.select { |assoc| assoc[:plurality] == :one }
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

    def search(search_query, model)
      kind = model.name.downcase
      res = index.search(search_query).deep_symbolize_keys
      res_ids = res[:hits].each_with_object({}) do |value, acc|
        if acc.key?(value[:kind])
          acc[value[:kind]] << value[:id]
        else
          acc[value[:kind]] = [value[:id]]
        end
      end
      model.where(id: res_ids[kind])
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
      model.find_in_batches do |group|
        # HACK: Rails 4.x doesn't have an in_batches method which returns scopes
        associated = associated_for(model.where(id: group.map(&:id)))
        serialized = group.map { |record| new(record, associated: associated[record.id]).as_json }
        index.add_objects(serialized)
      end
    end

    def applicable_associations_for(model)
      return [] unless _associations
      _associations.reject { |assoc| target_association_for(model, assoc[:association]).nil? }
    end

    def joins_hash_for(*keys)
      keys.flatten.each_with_object({}) do |key, acc|
        key_parts = key.to_s.split('.').map!(&:to_sym)
        key_parts.reduce(acc) do |hash, elem|
          hash[elem] ||= {}
        end
      end
    end

    def target_association_for(base, key)
      key.to_s.split('.').reduce(base) do |acc, k|
        acc = acc.klass if acc.is_a? ActiveRecord::Reflection::AbstractReflection
        return nil unless acc.reflections[k]
        acc.reflections[k]
      end
    end

    def select_for_association(association, column)
      return unless association
      "array_agg(DISTINCT #{association.table_name}.#{column})"
    end

    def pluck_for_associations(model, associations)
      <<-PLUCK
        #{model.table_name}.id#{',' unless associations.empty?}
        #{associations.map { |assoc|
          select_for_association(target_association_for(model, assoc[:association]), assoc[:attr])
        }.compact.join(', ')}
      PLUCK
    end

    def associated_for(records)
      # Get the model
      model = records.model
      # Get the associations which apply to this model
      associations = applicable_associations_for(model)
      # Generate the output hash keys
      association_keys = associations.map { |assoc| assoc[:name].to_sym }
      # Generate the joins hash
      joins_hash = joins_hash_for(associations.map { |x| x[:association] })
      # Generate the pluck string
      plucks = pluck_for_associations(model, associations)

      # Add the joins, group by the ID, pluck the data
      data = records.eager_load(joins_hash).group("#{model.table_name}.id").pluck(plucks)
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
  end

  delegate :index, to: :class

  def initialize(model, new: true, associated: nil)
    @_model = model
    @_new = new
    @_associated = associated || load_associated
  end

  def load_associated
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

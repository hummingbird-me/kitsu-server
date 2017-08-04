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
      self._associations << { attr: as, association: via, name: name }
    end
    alias_method :has_one, :has_many

    def _association_names
      @_association_names ||= self._associations.map { |assoc| assoc[:name] }
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
      model.find_in_batches do |group|
        # HACK: Rails 4.x doesn't have an in_batches method which returns scopes
        associated = associated_for(model.where(id: group.map(&:id)))
        serialized = group.map { |record| new(record, associated: associated[record.id]).as_json }
        index.add_objects(serialized)
      end
    end

    def applicable_associations_for(model)
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
        #{model.table_name}.id,
        #{associations.map { |assoc|
          select_for_association(target_association_for(model, assoc[:association]), assoc[:attr])
        }.compact.join(', ')}
      PLUCK
    end

    def associated_for(records)
      model = records.model
      associations = applicable_associations_for(model)
      association_keys = associations.map { |assoc| assoc[:name].to_sym }
      joins_hash = joins_hash_for(associations.map { |x| x[:association] })
      plucks = pluck_for_associations(model, associations)
      data = records.eager_load(joins_hash).group("#{model.table_name}.id").uniq.pluck(plucks)
      data.map { |(id, *values)|
        [id, association_keys.zip(values).to_h.transform_values(&:compact)]
      }.to_h
    end
  end

  delegate :index, to: :class

  def initialize(model, new: true, associated: {})
    @_model = model
    @_new = new
    @_associated = associated
  end

  def _attribute_names
    @_attribute_names ||= self.class._attribute_names.select { |m| _model.respond_to?(m) }
  end

  def _attributes
    set = Set.new(_attribute_names)
    self.class._attributes.select { |attr| set.include?(attr[:name]) }
  end

  def dirty?
    return true if _new

    _attributes.each do |attr|
      changed = "#{attr[:name]}_changed?"
      puts attr[:name]
      dirty = if respond_to?(changed) then send(changed)
              elsif _model.respond_to?(changed) then _model.send(changed)
              else true
              end
      puts 'dirty' if dirty
      dirty &&= rand(100.0) <= attr[:frequency] if attr[:frequency]
      return true if dirty
    end

    false
  end

  def save!
    return unless dirty?

    if _new
      index.add_object(as_json)
    else
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
      objectID: algolia_id
    }
  end

  def as_json(*)
    res = _attributes.each_with_object(base_attributes) do |attr, acc|
      value = respond_to?(attr[:name]) ? send(attr[:name]) : _model.send(attr[:name])
      acc[attr[:name]] = attr[:format] ? attr[:format].format(value) : value
    end
    res.merge!(_associated) if _associated
    res.transform_keys { |k| k.to_s.camelize(:lower) }
  end
end

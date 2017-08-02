class BaseIndex
  class_attribute :_attributes, :_index
  attr_reader :_model, :_new

  class << self
    def attribute(*names, frequency: nil, format: nil)
      self._attributes ||= []
      self._attributes += names.map do |name|
        { name: name.to_s, frequency: frequency, format: format }
      end
    end
    alias_method :attributes, :attribute

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
  end

  delegate :index, to: :class

  def initialize(model, new: true)
    @_model = model
    @_new = new
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
    res.transform_keys { |k| k.to_s.camelize(:lower) }
  end
end

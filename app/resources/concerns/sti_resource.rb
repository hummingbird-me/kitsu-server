module STIResource
  extend ActiveSupport::Concern

  def kind
    _model.type.demodulize.underscore.dasherize
  end

  def kind=(val)
    _model.type = type_for_kind(val)
  end

  def _replace_fields(field_data)
    type = type_for_kind(field_data[:attributes][:kind]).safe_constantize
    @model = @model.becomes(type) if type
    super
  end

  def type_for_kind(kind)
    "#{self.class._model_name}::#{kind.underscore.classify}"
  end

  included do
    attribute :kind
    filter :kind, apply: ->(records, values, _options) {
      kinds = values.map { |v| "#{_model_name}::#{v.underscore.classify}" }
      records.where(type: kinds)
    }
  end
end

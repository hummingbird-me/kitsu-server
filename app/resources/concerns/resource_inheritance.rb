module ResourceInheritance
  extend ActiveSupport::Concern

  def _replace_fields(field_data)
    super.tap do
      type = @model.class.send(:subclass_from_attributes, @model.attributes)
      @model = @model.becomes(type) if type
    end
  end
end

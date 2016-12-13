class BaseResource < JSONAPI::Resource
  abstract
  include BackportFindRecords
  include AuthenticatedResource
  include Pundit::Resource
  include SearchableResource

  def respond_to?(method_name, include_private = false)
    if method_name.to_s.end_with?('_id')
      _model.respond_to?(method_name, include_private)
    else
      super
    end
  end

  def self.apply_filter(records, filter, value, options)
    if value == '_none' || (value.is_a?(Array) && value[0] == '_none')
      records.where(filter => nil)
    else
      super
    end
  end

  def records_for(association_name, options={})
    records = _model.public_send(association_name)
    return records unless records.is_a?(ActiveRecord::Relation)
    super
  end
end

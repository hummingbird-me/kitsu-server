class BaseResource < JSONAPI::Resource
  abstract
  include BackportFindRecords
  include AuthenticatedResource
  include Pundit::Resource
  include SearchableResource

  def self.apply_filter(records, filter, value, options)
    if value == '_none' || (value.is_a?(Array) && value[0] == '_none')
      records.where(filter => nil)
    else
      super
    end
  end
end

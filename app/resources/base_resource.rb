class BaseResource < JSONAPI::Resource
  abstract
  include AuthenticatedResource
  include Pundit::Resource
  include SearchableResource

  attributes :created_at, :updated_at

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

  def self.apply_sort(records, order_options, options = {})
    return records unless order_options.any?

    order_options = order_options.map { |key, direction|
      [key, "#{direction} nulls last"]
    }.to_h

    order_options.each_pair do |field, direction|
      records = if field.to_s.include?('.')
                  super(records, { field => direction }, options)
                else
                  table = records.table_name
                  records.order(Arel.sql("#{table}.#{field} #{direction}"))
                end
    end
    records
  end
end

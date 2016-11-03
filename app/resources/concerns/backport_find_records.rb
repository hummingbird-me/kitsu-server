# Backport find_records from cerebris/jsonapi-resources#master
module BackportFindRecords
  extend ActiveSupport::Concern

  class_methods do
    def find(filters, options = {})
      resources_for(find_records(filters, options), options[:context])
    end

    def find_records(filters, options = {})
      context = options[:context]

      records = filter_records(filters, options)

      sort_criteria = options.fetch(:sort_criteria) { [] }
      order_options = construct_order_options(sort_criteria)

      records = sort_records(records, order_options, context)
      records = apply_pagination(records, options[:paginator], order_options)

      records
    end
  end
end

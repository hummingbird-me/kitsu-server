module SortableByFollowing
  extend ActiveSupport::Concern

  class_methods do
    def sortable_fields(context)
      if context[:current_user]
        super(context) + %i[following]
      else
        super(context)
      end
    end

    def sort_records(records, order_options, options = {})
      if order_options.delete('following')
        current_user = options[:current_user]&.resource_owner
        records = records.followed_first(current_user) if current_user
      end
      super(records, order_options, options)
    end
  end
end

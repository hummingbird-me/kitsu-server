module AuthorizedResource
  extend ActiveSupport::Concern

  include Pundit::Resource

  class_methods do
    def find(filters, options = {})
      records = find_records(filters, options)
      p records
      resources_for(records, options[:context])
    end
  end
end

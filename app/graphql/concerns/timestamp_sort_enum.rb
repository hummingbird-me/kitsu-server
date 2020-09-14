module TimestampSortEnum
  extend ActiveSupport::Concern

  included do
    value 'CREATED_AT', value: :created_at
    value 'UPDATED_AT', value: :updated_at
  end
end

class AMAResource < BaseResource
  attributes :description, :start_date, :end_date,
    :ama_subscribers_count

  has_one :author
  has_one :original_post
  has_many :ama_subscribers

  filters :end_date, :start_date, :ama_subscribers_count
end

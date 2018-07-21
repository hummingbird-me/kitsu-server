class MediaProduction < ApplicationRecord
  enum role: %i[producer licensor studio serialization]

  belongs_to :media, polymorphic: true, required: true
  belongs_to :company, class_name: 'Producer', required: true
end

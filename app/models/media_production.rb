class MediaProduction < ApplicationRecord
  enum role: { producer: 0, licensor: 1, studio: 2, serialization: 3 }

  belongs_to :media, polymorphic: true, optional: false
  belongs_to :company, class_name: 'Producer', optional: false
end

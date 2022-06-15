module Mappable
  extend ActiveSupport::Concern

  included do
    has_many :mappings, as: 'item', dependent: :destroy, inverse_of: :item
    accepts_nested_attributes_for :mappings
  end
end

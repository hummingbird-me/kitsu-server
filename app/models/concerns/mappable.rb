module Mappable
  extend ActiveSupport::Concern

  included do
    has_many :mappings, as: 'item', dependent: :destroy
  end
end

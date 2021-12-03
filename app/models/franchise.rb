class Franchise < ApplicationRecord
  include Titleable

  has_many :installments, dependent: :destroy
end

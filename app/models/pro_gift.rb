class ProGift < ApplicationRecord
  belongs_to :from, class_name: 'User', required: true
  belongs_to :to, class_name: 'User', required: true

  validates :message, length: { maximum: 500 }
end

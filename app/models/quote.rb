class Quote < ApplicationRecord
  include WithActivity

  # defaults to required: true in Rails 5
  belongs_to :user, required: true, counter_cache: true
  belongs_to :media, required: true, polymorphic: true
  belongs_to :character, required: true
  has_many :likes, class_name: 'QuoteLike', dependent: :destroy

  validates_presence_of :content
end

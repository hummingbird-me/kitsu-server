class Quote < ActiveRecord::Base
  # defaults to required: true in Rails 5
  belongs_to :user, required: true
  belongs_to :anime, required: true
  belongs_to :character, required: true

  validates_presence_of :content
end

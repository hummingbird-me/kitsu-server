class Video < ApplicationRecord
  include Streamable

  belongs_to :episode, optional: false
  validates :url, presence: true
end

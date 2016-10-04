class Comment < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :post, required: true

  validates :text, :text_formatted, presence: true

  before_validation do
    self.text_formatted = text
  end
end

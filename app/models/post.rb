class Post < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :target, class_name: 'User'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true

  validates :text, :text_formatted, presence: true
  validates :media, presence: true, if: :spoiled_unit
  validates :spoiler, acceptance: {
    accept: true,
    message: 'must be true if spoiled_unit is provided'
  }, if: :spoiled_unit

  before_validation do
    self.text_formatted = text
  end
end

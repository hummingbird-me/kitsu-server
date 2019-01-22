class Changeset < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :subject, polymorphic: true

  enum status: %i[submitted accepted partially_accepted rejected]

  def input_object
    root_type.safe_constantize.new(change_data, context: nil, defaults_used: Set.new)
  end

  delegate :apply, to: :input_object
end

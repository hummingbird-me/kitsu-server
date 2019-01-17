class ChangesetModeratorAction < ApplicationRecord
  belongs_to :moderator, class_name: 'User', required: true
  belongs_to :changeset, required: true

  enum action: %i[accepted rejected]
end

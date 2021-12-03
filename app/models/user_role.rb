class UserRole < ApplicationRecord
  self.table_name = 'users_roles'

  belongs_to :user, required: true
  belongs_to :role, required: true
end

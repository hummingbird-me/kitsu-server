class UserRole < ApplicationRecord
  self.table_name = 'users_roles'

  belongs_to :user, optional: false
  belongs_to :role, optional: false
end

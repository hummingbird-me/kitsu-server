# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users_roles
#
#  id      :integer          not null, primary key
#  role_id :integer          indexed => [user_id]
#  user_id :integer          indexed => [role_id]
#
# Indexes
#
#  index_users_roles_on_user_id_and_role_id  (user_id,role_id)
#
# rubocop:enable Metrics/LineLength

class UserRole < ApplicationRecord
  has_paper_trail
  self.table_name = 'users_roles'

  belongs_to :user, required: true
  belongs_to :role, required: true
end

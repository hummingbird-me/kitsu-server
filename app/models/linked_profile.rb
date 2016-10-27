# == Schema Information
#
# Table name: linked_profiles
#
#  id               :integer          not null, primary key
#  share_from       :boolean
#  share_to         :boolean
#  token            :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  external_user_id :integer
#  linked_site_id   :integer          indexed
#  user_id          :integer          indexed
#
# Indexes
#
#  index_linked_profiles_on_linked_site_id  (linked_site_id)
#  index_linked_profiles_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#  fk_rails_25de88e967  (linked_site_id => linked_sites.id)
#

class LinkedProfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :linked_site
end

# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  friend_id  :integer          indexed
#  user_id    :integer          indexed
#
# Indexes
#
#  index_friendships_on_friend_id  (friend_id)
#  index_friendships_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_e3733b59b7  (user_id => users.id)
#

class Friendship < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :friend, foreign_key: 'friend_id', class_name: 'User'
end

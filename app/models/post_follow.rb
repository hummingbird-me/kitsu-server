# == Schema Information
#
# Table name: post_follows
#
#  id         :integer          not null, primary key
#  activated  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          indexed
#  user_id    :integer          indexed
#
# Indexes
#
#  index_post_follows_on_post_id  (post_id)
#  index_post_follows_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_8cdaf33e9c  (user_id => users.id)
#  fk_rails_afb3620fdd  (post_id => posts.id)
#

class PostFollow < ActiveRecord::Base
  
  belongs_to :user, required: true, touch: true
  belongs_to :post, required: true

  validates :post, uniqueness: { scope: :user_id }

  def changed_status?
    @changed_status == true
  end

  before_save do 
  	@changed_status = :activated_changed
  end

  after_save do
  	if changed_status?
	  	if self.activated?
	  	  user.notifications.follow(post.feed)
	  	else
	  	  user.notifications.unfollow(post.feed)
	  	end
	end
  end

  after_destroy do
  	if self.activated?
  	  user.notifications.unfollow(post.feed)
    end
  end
end

# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :content             not null
#  content_formatted :content             not null
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  post_id           :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_2fd19c0db7  (post_id => posts.id)
#

class Comment < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :post, required: true

  validates :content, :content_formatted, presence: true

  before_validation do
    self.content_formatted = content
  end
end

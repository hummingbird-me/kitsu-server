class MediaAttribute < ActiveRecord::Base
  enum pacing %i[slow neutral fast]
  enum complexity %i[simple neutral complex]
  enum tone %i[light neutral dark]

  belongs_to :user, required: true, touch: true
  belongs_to :media, required: true, polymorphic: true

  validates :media, polymorphism: { type: Media }
  validates :multiple_vote , :uniqueness: { 
    :scope => :user_id
  }
  validates :user_id, uniqueness: {
    scope: :media_type,
    message: 'Cannot vote multiple times'
  }

  def multiple_vote
    if MediaAttribute.exists?(
        :user_id => user_id,
        :media_type => media_type,
        :media_id => media_id
      )
      errors.add(:user, "Cannot vote multiple times for the same item")
    end
 end
end

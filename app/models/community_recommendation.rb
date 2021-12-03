class CommunityRecommendation < ApplicationRecord
  include RetrieveMedia

  belongs_to :anime, optional: true
  belongs_to :manga, optional: true
  belongs_to :drama, optional: true
  belongs_to :media, polymorphic: true, required: true
  belongs_to :community_recommendation_request, required: true
  has_many :reasons, class_name: 'Post'

  def send_community_recommendation(reason)
    community_recommendation_request.feed.activities.new(
      target: reason,
      actor: reason.user,
      object: self,
      foreign_id: self,
      verb: self.class.name.underscore,
      time: Time.now
    ).create
  end
end

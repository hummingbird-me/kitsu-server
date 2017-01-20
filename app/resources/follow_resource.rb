class FollowResource < BaseResource
  has_one :follower
  has_one :followed

  filter :follower
  filter :followed

  def self.sortable_fields(context)
    super(context) << :created_at
  end
end

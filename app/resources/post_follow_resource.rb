class PostFollowResource < BaseResource
  attributes :activated, :created_at, :updated_at

  def self.updatable_fields(context)
    super - [:user, :post]
  end

  has_one :post
  has_one :user

  filter :post_id
  filter :user_id
end

class BlockResource < BaseResource
  has_one :user
  has_one :blocked

  filter :user

  def records_for(relation_name)
    return super unless relation_name == :user
    _model.public_send relation_name
  end
end

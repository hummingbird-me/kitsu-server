class Types::Block < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A blocked user entry of an Account.'

  field :id, ID, null: false

  field :user, Types::Profile,
    null: false,
    description: 'User who blocked.'

  def user
    Loaders::RecordLoader.for(User).load(object.user_id)
  end

  field :blocked_user, Types::Profile,
    null: false,
    description: 'User who got blocked.'

  def blocked_user
    Loaders::RecordLoader.for(User).load(object.blocked_id)
  end
end

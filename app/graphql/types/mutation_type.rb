class Types::MutationType < Types::BaseObject
  field :pro, Types::ProMutation, null: false
  field :anime, Types::AnimeMutation, null: false
end

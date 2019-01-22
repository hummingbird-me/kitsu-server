class Types::Changeset < Types::BaseObject
  field :id, ID, null: false
  field :user, Types::Profile, null: false
  field :status, Types::ChangesetStatus, null: false
  field :notes, String, null: true
  field :change_data, Types::Map, null: false
end

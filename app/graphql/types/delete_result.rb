class Types::DeleteResult < Types::BaseObject
  field :id, ID, null: false, description: 'ID of the deleted entity'
  field :type_name, String, null: false, description: 'Type of the deleted entity'
end

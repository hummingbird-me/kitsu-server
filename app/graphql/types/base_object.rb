class Types::BaseObject < GraphQL::Schema::Object
  connection_type_class(Types::BaseConnection)

  implements Types::Interface::WithTimestamps
end

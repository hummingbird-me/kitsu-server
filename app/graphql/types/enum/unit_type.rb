class Types::Enum::UnitType < Types::Enum::Base
  graphql_name 'UnitTypeEnum'

  value 'EPISODE', value: 'Episode'
  value 'CHAPTER', value: 'Chapter'
end
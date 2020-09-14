class Types::Enum::Sort::Profile < Types::Enum::Base
  include TimestampSortEnum

  value 'SLUG', value: :slug
  value 'NAME', value: :name
end

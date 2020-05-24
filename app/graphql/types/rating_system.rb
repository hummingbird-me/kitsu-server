class Types::RatingSystem < Types::BaseEnum
  value 'SIMPLE', 'Smileys', value: 'simple'
  value 'REGULAR', '1-10 whole numbers', value: 'regular'
  value 'ADVANCED', '1-100 whole numbers', value: 'advanced'
end

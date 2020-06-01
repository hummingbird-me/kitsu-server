class Types::RatingSystem < Types::BaseEnum
  value 'SIMPLE', 'Smileys', value: 'simple'
  value 'REGULAR', '5 Stars', value: 'regular'
  value 'ADVANCED', '1-20 displayed as 1-10 in 0.5 increments', value: 'advanced'
end

# frozen_string_literal: true

class Types::RatingSystem < Types::BaseEnum
  SIMPLE = '1-20 displayed as 4 smileys - Awful (1), Meh (8), Good (14) and Great (20)'
  REGULAR = '1-20 in increments of 2 displayed as 5 stars in 0.5 star increments'
  ADVANCED = '1-20 in increments of 1 displayed as 1-10 in 0.5 increments'

  value 'SIMPLE', SIMPLE, value: 'simple'
  value 'REGULAR', REGULAR, value: 'regular'
  value 'ADVANCED', ADVANCED, value: 'advanced'
end

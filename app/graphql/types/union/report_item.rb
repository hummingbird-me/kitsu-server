class Types::Union::ReportItem < Types::Union::Base
  description 'Objects which are Reportable'

  possible_types Types::Post, Types::Comment
end

# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.uncountable %w[anime manga media]
  inflect.acronym 'XML'
end

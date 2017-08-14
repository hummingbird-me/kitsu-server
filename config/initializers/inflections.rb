# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.uncountable %w[anime manga media anime_staff manga_staff drama_staff]
  inflect.acronym 'XML'
  inflect.acronym 'SSO'
  inflect.acronym 'STI'
  inflect.acronym 'AMA'
end

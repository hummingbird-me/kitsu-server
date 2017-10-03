require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Citext < RailsAdmin::Config::Fields::Types::String
          RailsAdmin::Config::Fields::Types::register(:citext, self)
        end
      end
    end
  end

  # Allow for searching/filtering of `citext` fields.
  module Adapters
    module ActiveRecord
      module CitextStatement
        private

        def build_statement_for_type
          if @type == :citext
            return build_statement_for_string_or_text
          else
            super
          end
        end
      end

      class StatementBuilder < RailsAdmin::AbstractModel::StatementBuilder
        prepend CitextStatement
      end
    end
  end
end

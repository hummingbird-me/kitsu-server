require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Duration < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          STR_TO_UNITS ||= {
            'd' => :days,
            'h' => :hours,
            'm' => :minutes,
            's' => :seconds
          }.freeze
          UNITS_TO_STR ||= STR_TO_UNITS.invert.freeze

          def form_default_value
            default_value if bindings[:object].new_record?
          end

          def length
            nil
          end

          def formatted_value
            return nil if value.blank?

            ActiveSupport::Duration.build(value).parts.map { |units, value|
              "#{value}#{UNITS_TO_STR[units]}"
            }.join
          end

          def parse_value(value)
            return if value.blank?

            # Split between the a-z and 0-9 characters using lookaheads+behinds
            value.split(/(?<=[a-z])(?=\d)/i).sum do |part|
              # Split between the 0-9 and a-z characters using lookaheads+behinds
              number, unit = part.split(/(?<=\d)(?=[a-z])/i)
              # Look up the first letter of the unit string (d/h/m/s) to get the unit method
              unit = unit ? STR_TO_UNITS[unit[0]] : :seconds
              # Convert to seconds
              number.to_i.try(unit)&.to_i || 0
            end
          end

          def parse_input(params)
            return unless params[name].is_a?(::String)
            params[name] = parse_value(params[name])
          end
        end
      end
    end
  end
end

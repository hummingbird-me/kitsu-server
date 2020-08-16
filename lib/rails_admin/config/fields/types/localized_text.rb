require 'rails_admin/config/fields/types/text'

module RailsAdmin
  module Config
    module Fields
      module Types
        class LocalizedText < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :html_attributes do
            {
              required: required?,
              cols: '70',
              rows: '10'
            }
          end

          def form_default_value
            default_value if bindings[:object].new_record?
          end

          def formatted_value
            return nil if value.blank?
            value.map { |(key, value)| "==#{key}\n#{value}" }.join("\n\n")
          end

          def parse_value(value)
            return if value.blank?

            section = 'en'
            value.each_line.each_with_object({ 'en' => '' }) do |line, obj|
              if line.start_with?('==')
                section = line[2..-1].strip
                obj[section] = ''
              else
                obj[section] << line
              end
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

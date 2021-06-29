module RailsAdmin
  module Config
    module Fields
      module Types
        class Flags < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types.register(self)

          def value
            bindings[:object].public_send(name)
          end

          def generic_help
            ''
          end

          register_instance_option :partial do
            :form_flags
          end

          register_instance_option :pairs do
            bindings[:object].class.send(name).pairs.transform_keys(&:titleize)
          end

          register_instance_option :pretty_value do
            bindings[:view].safe_join(value.flat_map do |flag|
              [
                bindings[:view].tag.span(flag.to_s.titleize, class: 'label label-primary'),
                ' '
              ]
            end)
          end
        end
      end
    end
  end
end

require 'generators/jsonapi/controller_generator'

module Rails
  module Generators
    class ResourceControllerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      check_class_collision suffix: 'Controller'

      def create_controller
        template_file = File.join(
          'app/controllers',
          class_path,
          "#{file_name.pluralize}_controller.rb"
        )
        template 'jsonapi_controller.rb', template_file
      end

      hook_for :authorization
      hook_for :serialization
    end
  end
end

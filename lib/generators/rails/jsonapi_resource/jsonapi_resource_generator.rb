module Rails
  module Generators
    class JsonapiResourceGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_resource
        template_file = File.join(
          'app/resources',
          class_path,
          "#{file_name.singularize}_resource.rb"
        )
        template 'resource.rb', template_file
      end
    end
  end
end

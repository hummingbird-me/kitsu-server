module Rails
  module Generators
    class PolicyGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_policy
        template_file = File.join(
          'app/policies',
          class_path,
          "#{file_name.singularize}_policy.rb"
        )
        template 'policy.rb', template_file
      end

      hook_for :test_framework do |instance, test|
        instance.invoke test, [instance.name.singularize]
      end
    end
  end
end

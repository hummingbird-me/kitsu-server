class Action
  module DSL
    extend ActiveSupport::Concern

    included do
      class_attribute :attribute_names
    end

    class_methods do
      # @param key [#to_s] the key to set up as a parameter
      # @param cast [Proc,nil] a function to convert an input object before calling
      # @param load [.find] an ActiveRecord class to load by ID from; overrides `cast`
      # @param required [Boolean] whether the parameter should be required
      # @return [void]
      def parameter(key, cast: nil, load: nil, required: false)
        # Set up the accessor
        attr_accessor(key)

        # Track all the attributes we've set up so far
        self.attribute_names ||= []
        self.attribute_names += [key.to_s]

        # Set up the loader if necessary
        cast = ->(input) { input.is_a?(load) ? input : load.find(input) } if load

        # Set up the casting in the setter method
        if cast
          define_method("#{key}=") { |input| instance_variable_set("@#{key}", cast.call(input)) }
        end

        # Set up validation if required
        validates key, presence: true if required
      end
    end
  end
end

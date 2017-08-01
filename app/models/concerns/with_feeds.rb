module WithFeeds
  extend ActiveSupport::Concern

  class_methods do
    def has_feed(name, class_name: nil, setup: true) # rubocop:disable Style/PredicateName
      # Memoization variable
      var = "@_#{name}_feed"
      # ClassName for feed
      class_name ||= "#{name.sub(/_feed\z/, '')}Feed".classify
      # Actual Class instance
      klass = class_name.safe_constantize

      # Define the getter
      define_method(name) do
        # Basically just @var ||= klass.new(id)
        return instance_variable_get(var) if instance_variable_defined?(var)
        instance_variable_set(var, klass.new(id))
      end

      # Define the setup hook if it hasn't been disaabled
      after_commit(on: :create) { send(name).setup! } if setup
    end
  end
end

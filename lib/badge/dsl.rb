class Badge
  module DSL
    extend ActiveSupport::Concern

    class_methods do
      def on(model, action = :save)
        return if model.nil?
        @model_class = model
        badge = self
        case action
        when :save
          model.after_save do
            user = if self.class == User
                     self
                   else
                     self.user
                   end
            badge.new(user).run
          end
        when :touch
          model.after_touch do
            user = if self.class == User
                     self
                   else
                     self.user
                   end
            badge.new(user).run
          end
        end
      end

      # Provide `key "value"` methods for each of these (also accept blocks)
      %i[progress title description].each do |attr|
        define_method(attr) do |value = nil, &block|
          if value || block
            instance_variable_set("@#{attr}", value || block)
          else
            instance_variable_get("@#{attr}".to_sym)
          end
        end
      end

      # Create a new rank within the current badge or returns the current
      # badge's rank
      def rank(value = nil, &block)
        return @rank if value.nil?
        subclass = const_set("Rank#{value}", Class.new(self, &block))
        subclass.rank = value
      end

      def rank=(value)
        @rank = value
      end

      def ranks
        constants.grep(/^Rank/)
      end

      # Declare the goal for the badge
      def bestow_when(value = nil)
        if value
          @goal = value
        elsif block_given?
          @goal = Proc.new
        end
      end

      def goal
        @goal
      end

      # Short-circuit hidden to set true
      def hidden
        @hidden = true
      end

      def hidden?
        @hidden
      end
    end
  end
end

module GroupActionLogger
  extend ActiveSupport::Concern

  def handle_log_action(action)
    # Get log target, group
    target = action_log_target.inject(_model, :public_send)
    group = (action_log_group || %i[group]).inject(_model, :public_send)
    # Execute to generate verb
    verbs = [_model.instance_exec(action, &action_log_verb)].flatten.compact

    verbs.each do |verb|
      group.action_logs.create!(
        target: target,
        verb: verb,
        user: actual_current_user
      )
    end
  end

  included do
    class_attribute :action_log_group
    class_attribute :action_log_target
    class_attribute :action_log_verb

    after_create { handle_log_action(:create) }
    after_remove { handle_log_action(:remove) }
    after_update { handle_log_action(:update) }
  end

  class_methods do
    def log_group(*keypath)
      self.action_log_group = [keypath].flatten
    end

    def log_target(*keypath)
      self.action_log_target = [keypath].flatten
    end

    def log_verb(verb = nil)
      self.action_log_verb = block_given? ? Proc.new : -> { verb }
    end
  end
end

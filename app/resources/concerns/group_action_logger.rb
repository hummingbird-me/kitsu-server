module GroupActionLogger
  extend ActiveSupport::Concern

  def handle_log_action(action)
    # Get log target, group
    target = @log_target.inject(_model, :public_send)
    group = (@log_group || %i[group]).inject(_model, :public_send)
    # Execute to generate verb
    verb = _model.instance_exec(action, &@log_verb)

    return unless verb

    group.action_logs.create!(
      target: target,
      verb: verb,
      user: actual_current_user
    )
  end

  included do
    after_create { handle_log_action(:create) }
    after_remove { handle_log_action(:remove) }
    after_update { handle_log_action(:update) }
  end

  class_methods do # rubocop:disable Metrics/BlockLength
    def log_group(*keypath)
      @log_group = [keypath].flatten
    end

    def log_target(*keypath)
      @log_target = [keypath].flatten
    end

    def log_verb(verb = nil)
      @log_verb = block_given? ? Proc.new : -> { verb }
    end
  end
end

module GroupActionLogger
  extend ActiveSupport::Concern

  class_methods do # rubocop:disable Metrics/BlockLength
    def log_action(group_keypath = %i[group], &block)
      if @default_log_action_enabled
        raise 'Cannot combine custom log_action with defaults'
      end

      group_keypath = [group_keypath].flatten
      after_create do
        group = group_keypath.inject(_model, :public_send)
        action_data = _model.instance_eval(&block)
        action_data[:user] = actual_current_user
        group.action_logs.create!(action_data)
      end
    end

    def log_target(keypath)
      @log_target = keypath
      setup_default_log_action
    end

    def log_verb(verb)
      @log_verb = verb.to_s
      setup_default_log_action
    end

    private

    # Configure log_action to use the default
    def setup_default_log_action
      return if @default_log_action_enabled

      log_action do
        target = @log_target.inject(_model, :public_send)
        { verb: @log_verb, log_target: target }
      end

      @default_log_action_enabled = true
    end
  end
end

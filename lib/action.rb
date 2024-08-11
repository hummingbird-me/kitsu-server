# An Action is a class representing a single task.  It's an implementation of the "command" pattern,
# comparable to the Interactors gem.  Unlike Interactors, however, Actions are based on ActiveModel,
# and are expected to raise an exception when they fail.
#
# == Why Not Interactors?
#
# Interactors implement a monadic error handling mechanism, which is cool but makes interop with
# other Ruby code rather difficult.  Interactors also rely on a shared "context" namespace for
# both passing arguments and returning results.
#
# = Implementing an Action
#
# To implement an Action, create a new file in the `app/actions` directory, and create a subclass of
# `Action`.  Generally, this will be in verb form, think "ResetPassword" or "CancelOrder".  Add any
# parameter declarations with the DSL, any validations (all ActiveModel validations should work!),
# and a `#call` method.  If you want to return something from an Action, return a hash which will be
# wrapped in an OpenStruct.  For example:
#
#     class ResetPassword < Action
#       parameter :email, required: true
#
#       def call
#         { delivery: UserMailer.reset_password(email).deliver_now }
#       end
#     end
#
# = Calling an Action
#
# Action classes act like Procs which take a hash as a parameter (defined by the `parameter` calls
# in the DSL) and return a Struct-like object.  To use an Action, simply `.call()` them, like this:
#
#     ResetPassword.call(email: 'help@kitsu.app')
#
# One thing to note is that any unknown parameters are silently ignored.
class Action
  include ActiveModel::Model
  include DSL

  def self.call(obj)
    result = new(obj).tap(&:validate!).call
    result.is_a?(Hash) ? OpenStruct.new(result) : result
  end

  def initialize(obj)
    # Slice our input to just the necessary attributes
    super(obj.stringify_keys.slice(*attribute_names))
  end

  # @return [Hash] the context of this action
  def context
    attribute_names.map { |k| [k, public_send(k)] }.to_h
  end
  # Alias for ActiveModel
  alias_method :attributes, :context

  # RAILS-5: replace with ActiveModel#validate!
  def validate!
    raise ValidationError, self unless valid?
  end
end

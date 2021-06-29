# Encapsulates a set of life-cycle callbacks on a class
class InstancedCallbacks
  attr_reader :record

  # @param record [ActiveRecord::Base] the record on which the callbacks are being run
  # @param options [Hash] a hash of options to this
  def initialize(record, options = {})
    @record = record
    @_options = options
  end

  # The options provided to this, wrapped in an OpenStruct
  def options
    @options ||= OpenStruct.new(@_options)
  end

  # Attach the callbacks to an ActiveSupport::Callbacks-enabled class
  # @param klass [ActiveSupport::Callbacks] the object to hook onto
  # @param options [Hash] a hash of options to this
  def self.hook(klass, options = {})
    this = self

    klass.define_method(name) do
      if instance_variable_defined?(:"@#{this.name}")
        instance_variable_get(:"@#{this.name}")
      else
        instance_variable_set(:"@#{this.name}", this.new(self, options))
      end
    end
  end

  # Attach a named callback to the class, calling the local method with the same name
  def self.attach_callback(klass, name)
    klass.send(name, wrap_callback(name))
  end

  # Returns a Proc which retrieves the instance from self and calls the given method on it
  # @param method [Symbol] the method to call
  def self.wrap_callback(method)
    instance_getter = :"#{name}"

    proc do
      send(instance_getter).send(method)
    end
  end
  private_class_method :wrap_callback
end

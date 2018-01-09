# Encapsulates a set of life-cycle callbacks on a class
class Callbacks
  attr_reader :record

  # @param record [ActiveRecord::Base] the record on which the callbacks are being run
  def initialize(record)
    @record = record
  end

  # @return [Hash] the options set for this callback group
  def options
    {}
  end

  # @return [Class] a class with the options set on itself
  def self.with_options(options)
    Class.new(self) do
      define_method(:options) { super().merge(options) }
    end
  end

  # Set up all the callback methods on the class itself so we can store the record as instance state
  %w[
    before_validation after_validation
    before_save around_save after_save
    before_create around_create after_create
    before_update around_update after_update
    before_destroy around_destroy after_destroy
    after_commit after_rollback
  ].each do |callback|
    define_singleton_method(callback) { |record| new(record).send(callback) }
  end
end

class AssociationLoader < GraphQL::Batch::Loader
  def self.validate(model, association_name)
    new(model, association_name)
    nil
  end

  def initialize(model, association_name, token: nil, policy: nil)
    @model = model
    @association_name = association_name
    @token = token
    @policy = (policy.presence || association_name).to_s

    validate
  end

  def scope(record)
    load(record).then do |associations|
      Promise.resolve(policy_klass.new(token, associations).resolve)
    end
  end

  # We want to load the associations on all records, even if they have the same id
  def cache_key(record)
    record.object_id
  end

  def perform(records)
    preload_association(records)
    records.each { |record| fulfill(record, read_association(record)) }
  end

  private

  attr_reader :token, :policy

  # This will return a Promise which we will chain the pundit scope onto.
  # All the cached data will be pre-pundit scoped.
  def load(record)
    unless record.is_a?(@model)
      raise TypeError, "#{@model} loader can't load association for #{record.class}"
    end
    return Promise.resolve(read_association(record)) if association_loaded?(record)
    super
  end

  def validate
    unless @model.reflect_on_association(@association_name)
      raise ArgumentError, "No association #{@association_name} on #{@model}"
    end
  end

  def policy_klass
    @policy_klass ||= "#{policy.classify}Policy::Scope".constantize
  end

  def preload_association(records)
    ::ActiveRecord::Associations::Preloader.new.preload(records, @association_name)
  end

  def read_association(record)
    record.public_send(@association_name)
  end

  def association_loaded?(record)
    record.association(@association_name).loaded?
  end
end

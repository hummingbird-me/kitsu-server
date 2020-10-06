class RecordLoader < GraphQL::Batch::Loader
  def initialize(model, column: model.primary_key, where: nil, policy: nil, token: nil)
    @model = model
    @column = column.to_s
    @column_type = model.type_for_attribute(@column)
    @where = where
    @policy = (policy.presence || model).to_s
    @token = token
  end

  def perform(keys)
    query(keys).each { |record| fulfill(record.public_send(@column), record) }

    keys.each { |key| fulfill(key, nil) unless fulfilled?(key) }
  end

  def query(keys)
    scope = @model
    scope = scope.where(@where) if @where

    policy_klass.new(token, scope.where(@column => keys)).resolve
  end

  def load(key)
    super(@column_type.cast(key))
  end

  private

  attr_reader :token, :policy

  def policy_klass
    @policy_klass ||= "#{policy.classify}Policy::Scope".constantize
  end
end

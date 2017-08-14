class AlgoliaKeyService
  def initialize(model, token)
    @model = model
    @index = model.algolia_index.safe_constantize
    @token = token
    @user = token&.resource_owner
  end

  def key
    @key ||= Algolia.generate_secured_api_key(search_key, restrictIndices: index, filters: scope)
  end

  def index
    @index.index_name
  end

  def scope
    return @scope if @scope
    policy = PolicyFinder.new(@model).policy
    @scope = policy::AlgoliaScope.new(@user).resolve
  rescue NameError
    nil
  end

  def self.search_key
    @search_key ||= ENV['ALGOLIA_SEARCH_KEY']
  end
  delegate :search_key, to: :class
  cattr_writer :search_key
end

module GraphQL
  class FancyLoader::PunditMiddleware
    def initialize(key:)
      @key = key
    end

    def call(model:, query:, context:)
      scope = ::Pundit::PolicyFinder.new(model).scope!
      user = context[@key]
      scope.new(user, query).resolve
    end
  end
end

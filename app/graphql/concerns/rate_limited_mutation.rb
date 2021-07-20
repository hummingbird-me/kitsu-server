module RateLimitedMutation
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :rate_limiter

    def rate_limit(&block)
      @rate_limiter = Strait.new("mutation-#{graphql_name}", &block)
    end
  end

  def ready?(*_args, **_kwargs)
    self.class.rate_limiter.limit!(current_user)
    super
  rescue Strait::RateLimitExceeded => e
    raise GraphQL::ExecutionError, ErrorI18n.t(e)
  end
end

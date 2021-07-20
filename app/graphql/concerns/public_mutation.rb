module PublicMutation
  extend ActiveSupport::Concern

  def authorized?(*_args, **_kwargs)
    true
  end
end

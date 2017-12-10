module CustomControllerHelpers
  extend ActiveSupport::Concern

  included do
    include Pundit
    skip_after_action :enforce_policy_use
  end

  def serialize_error(status, message)
    {
      errors: [
        {
          status: status,
          detail: message
        }
      ]
    }
  end

  def policy_for(model)
    Pundit.policy!(current_user, model)
  end

  def scope_for(model)
    Pundit.policy_scope!(current_user, model)
  end

  def show?(model)
    scope = model.class.where(id: model.id)
    scope_for(scope).exists?
  end

  def render_jsonapi(data, opts = {})
    render opts.merge(json: data, content_type: JSONAPI::MEDIA_TYPE)
  end

  def user
    doorkeeper_token&.resource_owner
  end

  def authenticate_user!
    render_jsonapi serialize_error(403, 'Must be logged in'), status: 403 unless user
  end
end

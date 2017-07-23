module AuthenticatedResource
  extend ActiveSupport::Concern

  def token
    # Sadly this is hardcoded into Pundit-Resources, so we just roll with it
    @context[:current_user]
  end

  def actual_current_user
    token&.resource_owner
  end

  def fetchable_fields
    all = super
    policy.try(:visible_attributes, all) || all
  end

  def replace_fields(field_data)
    allowed_fields = if _model.persisted?
                       all = self.class.updatable_fields(@context)
                       policy.try(:editable_attributes, all) || all
                     else
                       all = self.class.creatable_fields(@context)
                       policy.try(:creatable_attributes, all) ||
                         policy.try(:editable_attributes, all) ||
                         all
                     end
    used_fields = field_data.values.map(&:keys).inject(&:|)
    disallowed_fields = (used_fields - allowed_fields)
    unless disallowed_fields.empty?
      raise JSONAPI::Exceptions::ParametersNotAllowed, disallowed_fields
    end
    super
  end
end

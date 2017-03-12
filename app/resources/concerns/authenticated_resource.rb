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

  class_methods do
    def class_policy(context)
      Pundit.policy!(context[:current_user], _model_class)
    end

    def updatable_fields(context)
      policy = class_policy(context)
      all = super(context)
      policy.try(:editable_attributes, all) || all
    end

    def creatable_fields(context)
      policy = class_policy(context)
      all = super(context)
      policy.try(:creatable_attributes, all) ||
        policy.try(:editable_attributes, all) ||
        all
    end
  end
end

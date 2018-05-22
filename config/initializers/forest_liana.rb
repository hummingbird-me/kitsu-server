ForestLiana.env_secret = Rails.application.secrets.forest_env_secret
ForestLiana.auth_secret = Rails.application.secrets.forest_auth_secret

ForestLiana::ControllerFactory.class_eval do
  def controller_for(active_record_class)
    controller = Class.new(ForestLiana::ResourcesController) {}

    ForestLiana::ControllerFactory.define_controller(active_record_class, controller)
    controller
  end
end

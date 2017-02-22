require 'rails_admin/main_controller'
module RailsAdmin
  class MainController < RailsAdmin::ApplicationController
    def redirect_to_on_success
      notice = I18n.t('admin.flash.successful',
        name: @model_config.label,
        action: I18n.t("admin.actions.#{@action.key}.done"))
      if params[:_add_another]
        redirect_path = '/api' + new_path(return_to: params[:return_to])
        redirect_to redirect_path, flash: { success: notice }
      elsif params[:_add_edit]
        redirect_path = '/api' + edit_path(id: @object.id,
                                           return_to: params[:return_to])
        redirect_to redirect_path, flash: { success: notice }
      else
        redirect_path = '/api' + index_path
        redirect_to redirect_path
      end
    end
  end
end

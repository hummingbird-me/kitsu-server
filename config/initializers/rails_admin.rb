RailsAdmin.config do |config|
  config.parent_controller = '::AdminController'
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete do
      controller do
          proc do
            if request.get? # DELETE

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, layout: false }
              end

            elsif request.delete? # DESTROY

              redirect_path = nil
              @auditing_adapter && @auditing_adapter.delete_object(@object, @abstract_model, _current_user)
              if @object.destroy
                puts "DELETED!!!!"
                flash[:success] = t('admin.flash.successful', name: @model_config.label, action: t('admin.actions.delete.done'))
                redirect_path = "/api" + index_path
              else
                flash[:error] = t('admin.flash.error', name: @model_config.label, action: t('admin.actions.delete.done'))
                redirect_path = "/api" + back_or_index
              end

              redirect_to redirect_path

            end
          end
        end
    end
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

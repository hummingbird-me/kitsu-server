RailsAdmin::ApplicationHelper.module_eval do
  def menu_for(parent, abstract_model = nil, object = nil, only_icon = false)
    actions = actions(parent, abstract_model, object).select { |a| a.http_methods.include?(:get) }
    actions.collect { |action|
      wording = wording_for(:menu, action)
      %[
        <li title="#{wording if only_icon}" rel="#{'tooltip' if only_icon}" class="icon #{action.key}_#{parent}_link #{'active' if current_action?(action)}">
          <a class="#{action.pjax? ? 'pjax' : ''}" href="#{url_for(action: action.action_name, controller: 'rails_admin/main', model_name: abstract_model.try(:to_param), id: (object.try(:persisted?) && object.try(:id) || nil))}">
            <i class="#{action.link_icon}"></i>
            <span#{only_icon ? " style='display:none'" : ''}>#{wording}</span>
          </a>
        </li>
      ]
    }.join.html_safe
  end
end

class Types::Input::ProfileLink::Create < Types::Input::Base
  argument :url, String, required: true
  argument :profile_link_site_id, Types::Enum::ProfileLinksSites, required: true

  def to_model
    to_h.merge({ user_id: current_user&.id })
  end
end
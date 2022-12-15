class Types::Input::ProfileLink::Update < Types::Input::Base
  argument :url, String, required: true
  argument :profile_link_site_id, Types::Enum::ProfileLinksSites, required: true
end

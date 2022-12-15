class Types::Input::ProfileLink::Delete < Types::Input::Base
  argument :profile_link_site_id, Types::Enum::ProfileLinksSites, required: true
end

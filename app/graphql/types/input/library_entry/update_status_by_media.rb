class Types::Input::LibraryEntry::UpdateStatusByMedia < Types::Input::Base
  argument :media_id, ID, required: true
  argument :media_type, Types::Enum::MediaType, required: true
  argument :status, Types::Enum::LibraryEntryStatus, required: true
end

class Types::Input::LibraryEntry::UpdateStatusById < Types::Input::Base
  argument :id, ID, required: true
  argument :status, Types::Enum::LibraryEntryStatus, required: true
end

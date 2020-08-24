class Types::Input::LibraryEntry::UpdateProgressById < Types::Input::Base
  argument :id, ID, required: true
  argument :progress, Integer, required: true
end

class Types::Input::LibraryEntry::UpdateProgressByMedia < Types::Input::Base
  argument :media_id, ID, required: true
  argument :media_type, Types::Enum::MediaType, required: true
  argument :progress, Integer, required: true
end

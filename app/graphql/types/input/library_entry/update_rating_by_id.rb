class Types::Input::LibraryEntry::UpdateRatingById < Types::Input::Base
  argument :id, ID, required: true
  argument :rating, Integer, required: true
end

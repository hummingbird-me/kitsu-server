class Types::Enum::LibraryEntryStatus < Types::Enum::Base
  value 'CURRENT', 'The user is currently reading or watching this media.', value: :current
  value 'PLANNED', 'The user plans to read or watch this media in future.', value: :planned
  value 'COMPLETED', 'The user completed this media.', value: :completed
  value 'ON_HOLD', 'The user started but paused reading or watching this media.', value: :on_hold
  value 'DROPPED', 'The user started but chose not to finish this media.', value: :dropped
end

class Types::LibraryEntry::Status < Types::BaseEnum
  value 'current', 'Media that you currently read/watch.'
  value 'planned', 'Media that you plan to read/watch at some point.'
  value 'completed', 'Media that you have completed.'
  value 'on_hold', 'Media that you have started but decided to stop.'
  value 'dropped', 'Media that you will not complete.'
end

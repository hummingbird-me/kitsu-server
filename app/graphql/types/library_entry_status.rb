class Types::LibraryEntryStatus < Types::BaseEnum
  value 'current', 'Media you currently read/watch.'
  value 'planned', 'Media you plan to read/watch at some point.'
  value 'completed', 'Media you have completed.'
  value 'on_hold', 'Media you have started but decided to stop.'
  value 'dropped', 'Media you will not complete.'
end
